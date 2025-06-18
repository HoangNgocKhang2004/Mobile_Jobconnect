using Microsoft.AspNetCore.Mvc;
using HuitWorks.AdminWeb.Models.ViewModels;
using HuitWorks.AdminWeb.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using ClosedXML.Excel;

namespace HuitWorks.AdminWeb.Controllers
{
    public class EvaluationController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IWebHostEnvironment _env;
        public EvaluationController(IHttpClientFactory httpClientFactory, IWebHostEnvironment env)
        {
            _httpClientFactory = httpClientFactory;
            _env = env;
        }

        // GET: /AdminCandidateEvaluation
        // Controller: CandidateEvaluationController.cs
        public async Task<IActionResult> Index(
            string statusFilter = "All",
            int page = 1,
            int pageSize = 10)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");

            // 1) Lấy dữ liệu headers và details
            var headers = await client
                .GetFromJsonAsync<List<CandidateEvaluationDto>>("api/CandidateEvaluation")
              ?? new List<CandidateEvaluationDto>();
            var details = await client
                .GetFromJsonAsync<List<EvaluationDetailDto>>("api/EvaluationDetail")
              ?? new List<EvaluationDetailDto>();

            // 2) Nhóm scores theo EvaluationId
            var detailGroups = details
                .GroupBy(d => d.EvaluationId)
                .ToDictionary(g => g.Key, g => g.Select(x => x.Score).ToList());

            // 3) Build list all với AverageScore và Status
            var all = headers
                .OrderByDescending(h => h.CreatedAt)
                .Select(h =>
                {
                    detailGroups.TryGetValue(h.EvaluationId, out var scores);
                    scores ??= new List<int>();

                    double avg = scores.Any()
                        ? Math.Round(scores.Average(), 2)
                        : 0;
                    int total = scores.Count;
                    int zero = scores.Count(s => s == 0);

                    string status = total == 0 || zero == total
                        ? "Chưa đánh giá"
                        : zero == 0
                            ? "Đã chấm xong"
                            : "Chưa chấm xong";

                    return new CandidateEvaluationListItem
                    {
                        EvaluationId = h.EvaluationId,
                        IdJobPost = h.IdJobPost,
                        IdCandidate = h.IdCandidate,
                        CreatedAt = h.CreatedAt,
                        AverageScore = avg,
                        Status = status
                    };
                })
                .ToList();

            // 4) Tính các chỉ số cho card
            ViewBag.Totallist = all.Count;
            ViewBag.ChuaDanhGiaCount = all.Count(e => e.Status == "Chưa đánh giá");
            ViewBag.HoanThanhCount = all.Count(e => e.Status == "Đã chấm xong");
            ViewBag.DangChamCount = all.Count(e => e.Status == "Chưa chấm xong");

            // 5) Chuẩn bị dropdown status và lọc
            var allStatuses = new[] { "All", "Chưa đánh giá", "Chưa chấm xong", "Đã chấm xong" };
            ViewBag.StatusList = new SelectList(allStatuses, statusFilter);
            ViewBag.StatusFilter = statusFilter;

            var filtered = statusFilter == "All"
                ? all
                : all.Where(e => e.Status == statusFilter).ToList();

            // 6) Phân trang
            int totalItems = filtered.Count;
            int totalPages = Math.Max(1, (int)Math.Ceiling((double)totalItems / pageSize));
            page = Math.Clamp(page, 1, totalPages);

            var paged = filtered
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            // 7) Lấy title job và tên candidate để hiển thị
            var jobDict = new Dictionary<string, string>();
            var candDict = new Dictionary<string, string>();
            var jobIds = paged.Select(x => x.IdJobPost).Distinct();
            var candIds = paged.Select(x => x.IdCandidate).Distinct();

            foreach (var id in jobIds)
            {
                var job = await client.GetFromJsonAsync<JobPostingViewModel>($"api/JobPosting/{id}");
                jobDict[id] = job?.Title ?? "[Unknown job]";
            }
            foreach (var id in candIds)
            {
                var u = await client.GetFromJsonAsync<UserViewModel>($"api/User/{id}");
                candDict[id] = u?.UserName ?? "[Unknown student]";
            }
            ViewBag.JobDict = jobDict;
            ViewBag.CandDict = candDict;

            return View(paged);
        }




        // GET: /AdminCandidateEvaluation/Details/{id}
        public async Task<IActionResult> Details(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");

            // 1. Lấy header đánh giá
            var allEvals = await client.GetFromJsonAsync<List<CandidateEvaluationDto>>("/api/CandidateEvaluation");
            var header = allEvals.FirstOrDefault(e => e.EvaluationId == id);
            if (header == null) return NotFound();

            // 2. Lấy tất cả detail (có thể có duplicate)
            var allDetails = await client.GetFromJsonAsync<List<EvaluationDetailDto>>($"/api/EvaluationDetail?evaluationId={id}");

            // 3. Lọc chỉ giữ 1 detail cho mỗi criterionId (dùng bản đầu tiên)
            var details = allDetails
                .GroupBy(d => d.CriterionId)
                .Select(g => g.First())
                .ToList();

            // 4. Lấy tiêu chí để map tên, mô tả
            var criteria = await client.GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria");

            // 5. Build ViewModel: chỉ những criteria có detail, 1 hàng/tiêu chí
            var items = criteria
                .Where(c => details.Any(d => d.CriterionId == c.CriterionId))
                .Select(c =>
                {
                    var d = details.First(x => x.CriterionId == c.CriterionId);
                    return new EvaluateCandidateItem
                    {
                        CriterionId = c.CriterionId,
                        Name = c.Name,
                        Description = c.Description,
                        EvaluationDetailId = d.EvaluationDetailId,
                        Score = d.Score,
                        Comments = d.Comments,
                    };
                })
                .ToList();

            double avgScore = items.Any()
        ? Math.Round(items.Average(i => i.Score), 2)
        : 0;

            var vm = new EvaluateCandidateViewModel
            {
                EvaluationId = header.EvaluationId,
                IdJobPost = header.IdJobPost,
                IdCandidate = header.IdCandidate,
                IdRecruiter = header.IdRecruiter,
                Items = items,
                CreatedAt = header.CreatedAt,
                AverageScore = avgScore,
            };

            return View(vm);
        }


        // POST: /AdminCandidateEvaluation/Delete/{id}
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");

            // 1. Xoá tất cả detail
            var details = await client.GetFromJsonAsync<List<EvaluationDetailDto>>($"/api/EvaluationDetail?evaluationId={id}");
            foreach (var d in details)
            {
                await client.DeleteAsync($"/api/EvaluationDetail/{d.EvaluationDetailId}");
            }

            // 2. Xoá header
            await client.DeleteAsync($"/api/CandidateEvaluation/{id}");

            return RedirectToAction("Index");
        }
        public async Task<IActionResult> ExportToExcel(
        string statusFilter = "All")
        {
            var list = await BuildEvaluationList(statusFilter);

            var wb = new XLWorkbook();
            var ws = wb.Worksheets.Add("Evaluations");

            // Header
            string[] cols = { "ID", "Tin tuyển dụng", "Ứng viên",
                          "Ngày đánh giá", "Điểm TB", "Trạng thái" };
            for (int i = 0; i < cols.Length; i++)
                ws.Cell(1, i + 1).Value = cols[i];

            ws.Row(1).Style.Font.Bold = true;

            // Data
            int row = 2;
            foreach (var e in list)
            {
                ws.Cell(row, 1).Value = e.EvaluationId;
                ws.Cell(row, 2).Value = e.IdJobPost;
                ws.Cell(row, 3).Value = e.IdCandidate;
                ws.Cell(row, 4).Value = e.CreatedAt.ToLocalTime()
                                             .ToString("yyyy-MM-dd HH:mm");
                ws.Cell(row, 5).Value = e.AverageScore;
                ws.Cell(row, 6).Value = e.Status;
                row++;
            }

            // Auto-fit cho đẹp
            ws.Columns().AdjustToContents();

            var stream = new MemoryStream();
            wb.SaveAs(stream);
            stream.Position = 0;

            var fileName =
                $"evaluations_{DateTime.UtcNow:yyyyMMddHHmmss}.xlsx";

            return File(stream,
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                fileName);
        }


        public async Task<IActionResult> ExportAllDetails(string statusFilter = "All")
        {
            // 1) Lấy dữ liệu header và detail
            var headers = await BuildEvaluationList(statusFilter);
            var client = _httpClientFactory.CreateClient("ApiClient");
            var details = await client
                .GetFromJsonAsync<List<EvaluationDetailDto>>("/api/EvaluationDetail")
              ?? new List<EvaluationDetailDto>();
            var criteria = await client
                .GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria")
              ?? new List<EvaluationCriteriaDto>();
            var criDict = criteria.ToDictionary(c => c.CriterionId);

            // 2) Lấy tiêu đề công việc và CompanyId
            var jobIds = headers.Select(h => h.IdJobPost).Distinct();
            var jobTitleDict = new Dictionary<string, string>();
            var jobToCompId = new Dictionary<string, string>();
            foreach (var jobId in jobIds)
            {
                var job = await client.GetFromJsonAsync<JobPostingViewModel>($"/api/JobPosting/{jobId}");
                jobTitleDict[jobId] = job?.Title ?? jobId;
                jobToCompId[jobId] = job?.IdCompany ?? "";
            }

            // 3) Lấy tên công ty
            var compDict = new Dictionary<string, string>();
            var compIds = jobToCompId.Values
                          .Where(cid => !string.IsNullOrEmpty(cid))
                          .Distinct();
            foreach (var cid in compIds)
            {
                var comp = await client.GetFromJsonAsync<CompanyViewModel>($"/api/Companies/{cid}");
                compDict[cid] = comp?.CompanyName ?? "(Không có dữ liệu)";
            }

            // 4) Lấy tên ứng viên và nhà tuyển dụng
            var candIds = headers.Select(h => h.IdCandidate).Distinct();
            var recIds = headers.Select(h => h.IdRecruiter).Distinct();
            var candDict = new Dictionary<string, string>();
            var recDict = new Dictionary<string, string>();
            foreach (var id in candIds)
            {
                var u = await client.GetFromJsonAsync<UserViewModel>($"/api/User/{id}");
                candDict[id] = u?.UserName ?? id;
            }
            foreach (var id in recIds)
            {
                var u = await client.GetFromJsonAsync<UserViewModel>($"/api/User/{id}");
                recDict[id] = u?.UserName ?? id;
            }

            // 5) Tạo workbook & worksheet
            using var wb = new XLWorkbook();
            var ws = wb.Worksheets.Add("AllDetails");

            // 6) Chèn logo và header chung
            ws.Column(1).Width = 15;
            ws.Column(2).Width = 4;
            var logoPath = Path.Combine(_env.WebRootPath, "images", "logo.png");
            if (System.IO.File.Exists(logoPath))
            {
                ws.AddPicture(logoPath)
                  .MoveTo(ws.Cell("A2"))
                  .WithSize(80, 80);
            }
            ws.Row(2).Height = 25;
            ws.Row(3).Height = 25;
            ws.Row(4).Height = 5;
            ws.Row(5).Height = 30;
            ws.Row(6).Height = 20;
            ws.Row(7).Height = 5;

            ws.Range("C2:F2").Merge().SetValue("BỘ CÔNG THƯƠNG")
              .Style.Font.SetBold().Font.FontSize = 12;
            ws.Range("C2:F2").Style
              .Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left)
              .Alignment.SetVertical(XLAlignmentVerticalValues.Center);

            ws.Range("C3:F3").Merge().SetValue("TRƯỜNG ĐẠI HỌC CÔNG THƯƠNG TP.HCM")
              .Style.Font.SetBold().Font.FontSize = 12;
            ws.Range("C3:F3").Style
              .Alignment.SetHorizontal(XLAlignmentHorizontalValues.Left)
              .Alignment.SetVertical(XLAlignmentVerticalValues.Center);

            ws.Range("C5:K5").Merge()
              .SetValue("DANH SÁCH CHẤM ĐIỂM ĐÁNH GIÁ CỦA DOANH NGHIỆP ĐỐI VỚI SINH VIÊN")
              .Style.Font.SetBold().Font.FontSize = 14;
            ws.Range("C5:K5").Style
              .Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center)
              .Alignment.SetVertical(XLAlignmentVerticalValues.Center);

            ws.Range("C6:K6").Merge().SetValue("NĂM HỌC 2024 - 2025")
              .Style.Font.SetItalic().Font.FontSize = 12;
            ws.Range("C6:K6").Style
              .Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center)
              .Alignment.SetVertical(XLAlignmentVerticalValues.Center);

            // 7) Tạo header bảng ở row 8
            string[] colNames = {
        "ID", "Mssv", "Sinh viên", "Công ty", "Nhà tuyển dụng",
        "Tin tuyển dụng", "Ngày đánh giá",
        "Tiêu chí", "Mô tả", "Điểm", "Nhận xét"
    };
            int headerRow = 8;
            for (int c = 0; c < colNames.Length; c++)
                ws.Cell(headerRow, c + 3).SetValue(colNames[c]);

            // Style header và tắt wrap text
            var headerRange = ws.Range(headerRow, 3, headerRow, 2 + colNames.Length);
            headerRange.Style.Font.SetBold()
                               .Font.FontColor = XLColor.White;
            headerRange.Style.Fill.SetBackgroundColor(XLColor.DarkGreen);
            headerRange.Style.Alignment.WrapText = false;
            headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            headerRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

            // 8) Điền dữ liệu và ghi lại vùng cần merge
            int rowIdx = headerRow + 1;
            var mergeMap = new Dictionary<string, (int start, int end)>();
            foreach (var h in headers)
            {
                var block = details.Where(d => d.EvaluationId == h.EvaluationId).ToList();
                if (!block.Any()) continue;

                int startRow = rowIdx;
                foreach (var d in block)
                {
                    criDict.TryGetValue(d.CriterionId, out var cri);
                    var compId = jobToCompId[h.IdJobPost];

                    ws.Cell(rowIdx, 3).Value = h.EvaluationId;
                    ws.Cell(rowIdx, 4).Value = h.IdCandidate;
                    ws.Cell(rowIdx, 5).Value = candDict[h.IdCandidate];
                    ws.Cell(rowIdx, 6).Value = compDict.GetValueOrDefault(compId, "(Không có dữ liệu)");
                    ws.Cell(rowIdx, 7).Value = recDict[h.IdRecruiter];
                    ws.Cell(rowIdx, 8).Value = jobTitleDict[h.IdJobPost];
                    ws.Cell(rowIdx, 9).Value = h.CreatedAt.ToLocalTime().ToString("yyyy-MM-dd HH:mm");
                    ws.Cell(rowIdx, 10).Value = cri?.Name ?? "(unknown)";
                    ws.Cell(rowIdx, 11).Value = cri?.Description ?? "";
                    ws.Cell(rowIdx, 12).Value = d.Score;
                    ws.Cell(rowIdx, 13).Value = d.Comments;

                    rowIdx++;
                }
                mergeMap[h.EvaluationId] = (startRow, rowIdx - 1);
            }

            // 9) Merge cột C→I cho mỗi block
            foreach (var (start, end) in mergeMap.Values)
                if (start < end)
                    for (int c = 3; c <= 9; c++)
                        ws.Range(start, c, end, c).Merge();

            // 10) Style toàn vùng dữ liệu
            var dataRange = ws.Range(headerRow, 3, rowIdx - 1, 2 + colNames.Length);
            dataRange.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
            dataRange.Style.Border.InsideBorder = XLBorderStyleValues.Thin;
            dataRange.Style.Alignment.WrapText = true;
            dataRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            dataRange.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

            // ★ Auto-fit tất cả cột từ C đến cuối để vừa với nội dung ★
            ws.Columns(3, 2 + colNames.Length).AdjustToContents();

            ws.Rows().AdjustToContents();
            ws.SheetView.FreezeRows(headerRow);

            // 11) Xuất file
            using var ms = new MemoryStream();
            wb.SaveAs(ms);
            var bytes = ms.ToArray();
            var fileName = $"danhgia_sinhvien_{DateTime.UtcNow:yyyyMMddHHmmss}.xlsx";

            return File(
                bytes,
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                fileName
            );
        }



        /* ==============================================================
           =====================  HÀM TÁI SỬ DỤNG  ======================
           ==============================================================*/
        private async Task<List<CandidateEvaluationListItem>>
            BuildEvaluationList(string statusFilter)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            var headers = await client.GetFromJsonAsync<List<CandidateEvaluationDto>>
                                          ("/api/CandidateEvaluation") ?? new();
            var details = await client.GetFromJsonAsync<List<EvaluationDetailDto>>
                                          ("/api/EvaluationDetail") ?? new();

            var detailGroups = details
                .GroupBy(d => d.EvaluationId)
                .ToDictionary(g => g.Key, g => g.Select(x => x.Score).ToList());

            var list = headers.Select(h =>
            {
                detailGroups.TryGetValue(h.EvaluationId, out var scores);
                scores ??= new List<int>();

                double avg = scores.Any() ? Math.Round(scores.Average(), 2) : 0;
                int zero = scores.Count(s => s == 0);

                string status = scores.Count == 0 || zero == scores.Count
                                ? "Chưa đánh giá"
                                : zero == 0 ? "Đã chấm xong"
                                            : "Chưa chấm xong";

                return new CandidateEvaluationListItem
                {
                    EvaluationId = h.EvaluationId,
                    IdJobPost = h.IdJobPost,
                    IdCandidate = h.IdCandidate,
                    IdRecruiter = h.IdRecruiter,
                    CreatedAt = h.CreatedAt,
                    AverageScore = avg,
                    Status = status
                };
            })
            .OrderByDescending(x => x.CreatedAt)
            .ToList();

            return statusFilter == "All"
                   ? list
                   : list.Where(l => l.Status == statusFilter).ToList();
        }

        // ---------- dùng lại logic Details ----------
        private async Task<EvaluateCandidateViewModel?> BuildDetailViewModel(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");

            var hdr = (await client
                .GetFromJsonAsync<List<CandidateEvaluationDto>>("/api/CandidateEvaluation"))
                ?.FirstOrDefault(e => e.EvaluationId == id);
            if (hdr == null) return null;

            var details = await client
                .GetFromJsonAsync<List<EvaluationDetailDto>>
                    ($"/api/EvaluationDetail/{id}") ?? new();
            details = details
                .GroupBy(d => d.CriterionId)
                .Select(g => g.First()).ToList();

            var criteria = await client
                .GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria")
                ?? new();

            var items = criteria
                .Where(c => details.Any(d => d.CriterionId == c.CriterionId))
                .Select(c =>
                {
                    var d = details.First(x => x.CriterionId == c.CriterionId);
                    return new EvaluateCandidateItem
                    {
                        CriterionId = c.CriterionId,
                        Name = c.Name,
                        Description = c.Description,
                        Score = d.Score,
                        Comments = d.Comments
                    };
                })
                .ToList();

            return new EvaluateCandidateViewModel
            {
                EvaluationId = hdr.EvaluationId,
                IdJobPost = hdr.IdJobPost,
                IdCandidate = hdr.IdCandidate,
                IdRecruiter = hdr.IdRecruiter,
                CreatedAt = hdr.CreatedAt,
                AverageScore = items.Any() ? Math.Round(items.Average(i => i.Score), 2) : 0,
                Items = items
            };
        }
    }
}
