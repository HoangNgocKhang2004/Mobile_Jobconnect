// File: Controllers/JobPostingController.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;
using HuitWorks.WebAPI.Services;
using Microsoft.Extensions.Logging; // Để logging

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobPostingController : ControllerBase
    {
        private readonly JobConnectDbContext _context;
        private readonly IGeocodingService _geocodingService;
        private readonly ILogger<JobPostingController> _logger; // Thêm Logger

        public JobPostingController(
            JobConnectDbContext context,
            IGeocodingService geocodingService,
            ILogger<JobPostingController> logger) // Inject Logger
        {
            _context = context;
            _geocodingService = geocodingService;
            _logger = logger;
        }

        private string GetCurrentUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value
                   ?? User.FindFirst("sub")?.Value
                   ?? "";
        }

        // =========================================================================
        // GET: api/jobposting
        // Lấy các job còn hạn
        // =========================================================================
        [HttpGet]
        public async Task<ActionResult<IEnumerable<JobPostingDto>>> GetAll()
        {
            var jobPostings = await _context.JobPostings
                .Where(jp => jp.ApplicationDeadline == null || jp.ApplicationDeadline >= DateTime.UtcNow) // Xử lý ApplicationDeadline nullable
                .Where(jp => jp.PostStatus == "open") // Chỉ lấy job open hoặc waiting
                .Include(jp => jp.Company)
                .OrderByDescending(jp => jp.IsFeatured) // Ưu tiên featured
                .ThenByDescending(jp => jp.CreatedAt)  // Rồi mới nhất
                .ToListAsync();

            return Ok(jobPostings);
        }

        // =========================================================================
        // GET: api/jobposting/all
        // Lấy tất cả job, bao gồm cả hết hạn (cho admin hoặc mục đích quản lý)
        // =========================================================================
        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<JobPostingDto>>> GetAllIncludingExpired()
        {
            var jobPostings = await _context.JobPostings
                .Include(jp => jp.Company)
                .OrderByDescending(jp => jp.CreatedAt)
                .ToListAsync();

            return Ok(jobPostings);
        }

        // =========================================================================
        // GET: api/jobposting/featured
        // Lấy các job nổi bật và còn hạn
        // =========================================================================
        [HttpGet("featured")]
        public async Task<ActionResult<IEnumerable<JobPostingDto>>> GetAllFeatured()
        {
            var jobPostings = await _context.JobPostings
                .Where(jp => jp.IsFeatured == 1 && (jp.ApplicationDeadline == null || jp.ApplicationDeadline >= DateTime.UtcNow))
                .Where(jp => jp.PostStatus == "open")
                .Include(jp => jp.Company)
                .OrderByDescending(jp => jp.CreatedAt)
                .ToListAsync();

            return Ok(jobPostings);
        }

        // =========================================================================
        // GET: api/jobposting/company/{companyId}
        // =========================================================================
        //[HttpGet("company/{companyId}")]
        //public async Task<ActionResult<IEnumerable<JobPostingDto>>> GetByCompany(string companyId)
        //{
        //    var list = await _context.JobPostings
        //        .Where(jp => jp.IdCompany == companyId && jp.ApplicationDeadline == null || jp.ApplicationDeadline >= DateTime.UtcNow)
        //        .Include(jp => jp.Company) // Include company để map sang DTO
        //        .OrderByDescending(jp => jp.CreatedAt)
        //        .ToListAsync();

        //    return Ok(list);
        //}
        [HttpGet("company/{companyId}")]
        public async Task<ActionResult<IEnumerable<JobPostingDto>>> GetByCompany(string companyId)
        {
            var list = await _context.JobPostings
                .Where(jp => jp.IdCompany == companyId)
                .Include(jp => jp.Company)
                .OrderByDescending(jp => jp.CreatedAt)
                .Select(jp => new JobPostingDto
                {
                    IdJobPost = jp.IdJobPost,
                    Title = jp.Title,
                    Description = jp.Description,
                    Requirements = jp.Requirements,
                    Salary = jp.Salary,
                    Location = jp.Location,
                    Latitude = jp.Latitude,
                    Longitude = jp.Longitude,
                    WorkType = jp.WorkType,
                    ExperienceLevel = jp.ExperienceLevel,
                    IdCompany = jp.IdCompany,
                    ApplicationDeadline = jp.ApplicationDeadline,
                    Benefits = jp.Benefits,
                    CreatedAt = jp.CreatedAt,
                    UpdatedAt = jp.UpdatedAt,
                    IsFeatured = jp.IsFeatured,
                    PostStatus = jp.PostStatus,
                    Company = jp.Company == null ? null : new CompanyDto
                    {
                        IdCompany = jp.Company.IdCompany,
                        CompanyName = jp.Company.CompanyName,
                        LogoCompany = jp.Company.LogoCompany
                    }
                })
                .ToListAsync();

            return Ok(list);
        }
        // =========================================================================
        // GET: api/jobposting/search
        // Tìm kiếm job theo từ khóa (title, description) và/hoặc vị trí (chuỗi con)
        // Ví dụ: /api/jobposting/search?keyword=developer&location=Ho%20Chi%20Minh
        // =========================================================================
        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<JobPostingDto>>> SearchJobs(
            [FromQuery] string? locationQuery)
        {
            var query = _context.JobPostings
                .Where(jp => jp.PostStatus == "open" || jp.PostStatus == "waiting")
                .Include(jp => jp.Company)
                .AsQueryable();

            if (string.IsNullOrWhiteSpace(locationQuery))
            {
                return BadRequest(new { message = "locationQuery là bắt buộc." });
            }
            else
            {
                // Nếu có locationQuery, thực hiện tìm kiếm
                string searchLocationTerm = locationQuery.ToLower().Trim();

                // query = query.Where(jp => jp.Location != null &&
                //                          RemoveDiacritics(jp.Location.ToLower()).Contains(RemoveDiacritics(searchLocationTerm)));
                // (Bạn cần có hàm RemoveDiacritics ở backend)

                // Hiện tại, tìm kiếm trực tiếp bằng Contains trên chuỗi đã ToLower()
                query = query.Where(jp => jp.Location != null &&
                                         jp.Location.ToLower().Contains(searchLocationTerm) && jp.ApplicationDeadline == null || jp.ApplicationDeadline >= DateTime.UtcNow);
                _logger.LogInformation("Searching jobs with locationQuery: {LocationQuery}", locationQuery);
            }

            var results = await query
                .OrderByDescending(jp => jp.IsFeatured) // Ưu tiên job nổi bật
                .ThenByDescending(jp => jp.CreatedAt)  // Sau đó ưu tiên job mới nhất
                .Select(jp => jp)  // Map kết quả sang DTO
                .ToListAsync();

            _logger.LogInformation("Found {Count} jobs for locationQuery: '{LocationQuery}'", results.Count, locationQuery ?? "N/A");
            return Ok(results);
        }


        // =========================================================================
        // GET: api/jobposting/{id}
        // =========================================================================
        [HttpGet("{id}")]
        public async Task<ActionResult<JobPostingDto>> GetById(string id) // Trả về DTO
        {
            var jobPosting = await _context.JobPostings
                .Include(jp => jp.Company)
                .FirstOrDefaultAsync(jp => jp.IdJobPost == id);

            if (jobPosting == null)
                return NotFound(new { message = "Không tìm thấy tin tuyển dụng." });

            return Ok(jobPosting); // Map sang DTO
        }

        // =========================================================================
        // POST: api/jobposting
        // =========================================================================
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateJobPostingDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // 1) Xác thực công ty tồn tại
            if (!await _context.Companies.AnyAsync(c => c.IdCompany == dto.IdCompany))
                return BadRequest(new { message = $"Công ty '{dto.IdCompany}' không tồn tại." });

            // 2) Xác thực transaction (quota)
            var recruiterId = GetCurrentUserId();
            var activeTx = await _context.JobTransactions
                .Where(t => t.IdUser == recruiterId
                         && t.ExpiryDate >= DateTime.UtcNow
                         && t.RemainingJobPosts > 0)
                .OrderByDescending(t => t.ExpiryDate)
                .FirstOrDefaultAsync();
            if (activeTx == null)
                return BadRequest(new { message = "Bạn không có quota đăng tin hợp lệ." });

            // 3) Geocode nếu cần
            decimal? latitude = dto.Latitude;
            decimal? longitude = dto.Longitude;
            if ((!latitude.HasValue || !longitude.HasValue)
                 && !string.IsNullOrWhiteSpace(dto.Location))
            {
                var coords = await _geocodingService.GetCoordinatesAsync(dto.Location);
                if (coords != null)
                {
                    latitude = coords.Latitude;
                    longitude = coords.Longitude;
                }
            }

            // 4) Tạo JobPosting mới
            var now = DateTime.UtcNow;
            var newJob = new JobPosting
            {
                IdJobPost = Guid.NewGuid().ToString(),
                Title = dto.Title,
                Description = dto.Description,
                Requirements = dto.Requirements,
                Salary = dto.Salary,
                Location = dto.Location,
                Latitude = latitude,
                Longitude = longitude,
                WorkType = dto.WorkType,
                ExperienceLevel = dto.ExperienceLevel,
                IdCompany = dto.IdCompany,
                ApplicationDeadline = dto.ApplicationDeadline,
                Benefits = dto.Benefits,
                CreatedAt = now,
                UpdatedAt = now,
                PostStatus = "waiting",
                IsFeatured = 0
            };

            // 5) Trừ quota và ghi log
            activeTx.RemainingJobPosts--;
            _context.JobTransactions.Update(activeTx);

            var usageLog = new JobPostUsageLog
            {
                IdLog = Guid.NewGuid().ToString(),      // gán khoá chính
                IdTransaction = activeTx.IdTransaction,         // FK sang transaction
                IdJobPost = newJob.IdJobPost,               // FK sang job vừa tạo
                UsedAt = now
            };
            _context.JobPostUsageLogs.Add(usageLog);

            // 6) Thêm job và lưu
            _context.JobPostings.Add(newJob);
            await _context.SaveChangesAsync();

            // 7) Tải company để trả về DTO
            newJob.Company = await _context.Companies.FindAsync(newJob.IdCompany);

            return CreatedAtAction(
                nameof(GetById),
                new { id = newJob.IdJobPost },
                newJob
            );
        }


        // =========================================================================
        // PUT: api/jobposting/{id}
        // =========================================================================
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdateJobPostingDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var entity = await _context.JobPostings.FindAsync(id);
            if (entity == null)
            {
                return NotFound(new { message = "Không tìm thấy tin tuyển dụng." });
            }

            // Optional: Kiểm tra quyền sở hữu hoặc vai trò admin trước khi cho phép cập nhật
            // var currentUserId = GetCurrentUserId();
            // var companyOfJob = await _context.Companies.FirstOrDefaultAsync(c => c.IdCompany == entity.IdCompany);
            // if (companyOfJob?.IdUser != currentUserId /* && !User.IsInRole("Admin") */)
            // {
            //    return Forbid("Bạn không có quyền chỉnh sửa tin này.");
            // }

            bool locationOrCoordsChanged = false;

            if (!string.IsNullOrEmpty(dto.Title)) entity.Title = dto.Title;
            if (!string.IsNullOrEmpty(dto.Description)) entity.Description = dto.Description;
            if (!string.IsNullOrEmpty(dto.Requirements)) entity.Requirements = dto.Requirements;
            if (dto.Salary.HasValue) entity.Salary = dto.Salary.Value; else entity.Salary = null;

            if (!string.IsNullOrEmpty(dto.Location) && entity.Location != dto.Location)
            {
                entity.Location = dto.Location;
                locationOrCoordsChanged = true;
            }

            if (dto.Latitude.HasValue)
            {
                if (entity.Latitude != dto.Latitude.Value) locationOrCoordsChanged = true;
                entity.Latitude = dto.Latitude.Value;
            }
            if (dto.Longitude.HasValue)
            {
                if (entity.Longitude != dto.Longitude.Value) locationOrCoordsChanged = true;
                entity.Longitude = dto.Longitude.Value;
            }

            if (locationOrCoordsChanged && (!dto.Latitude.HasValue || !dto.Longitude.HasValue) && !string.IsNullOrWhiteSpace(entity.Location))
            {
                _logger.LogInformation("Address or coordinates changed for job {JobId}, attempting to re-geocode: {Location}", id, entity.Location);
                var coordinates = await _geocodingService.GetCoordinatesAsync(entity.Location);
                if (coordinates != null)
                {
                    entity.Latitude = coordinates.Latitude;
                    entity.Longitude = coordinates.Longitude;
                    _logger.LogInformation("Re-geocoded '{Location}' to Lat: {Latitude}, Lon: {Longitude}", entity.Location, entity.Latitude, entity.Longitude);
                }
                else
                {
                    _logger.LogWarning("Could not re-geocode new address: {Location}. Coordinates might be outdated or null.", entity.Location);
                    entity.Latitude = null;
                    entity.Longitude = null;
                }
            }

            if (!string.IsNullOrEmpty(dto.WorkType)) entity.WorkType = dto.WorkType;
            if (!string.IsNullOrEmpty(dto.ExperienceLevel)) entity.ExperienceLevel = dto.ExperienceLevel;
            if (dto.ApplicationDeadline.HasValue) entity.ApplicationDeadline = dto.ApplicationDeadline.Value; else entity.ApplicationDeadline = null;
            if (!string.IsNullOrEmpty(dto.Benefits)) entity.Benefits = dto.Benefits; else entity.Benefits = null;

            // Xử lý cập nhật PostStatus và xóa JobSaved nếu cần
            bool postStatusChangedToInvalid = false;
            if (!string.IsNullOrEmpty(dto.PostStatus))
            {
                // Kiểm tra xem PostStatus có thay đổi thành "closed" hoặc "editing" không
                if ((dto.PostStatus == "closed" || dto.PostStatus == "editing") && entity.PostStatus != dto.PostStatus)
                {
                    postStatusChangedToInvalid = true;
                }
                entity.PostStatus = dto.PostStatus;
            }

            entity.UpdatedAt = DateTime.UtcNow;

            // Nếu PostStatus được cập nhật thành "closed" hoặc "editing"
            // HOẶC nếu trạng thái hiện tại (sau khi cập nhật từ DTO) là "closed" hoặc "editing"
            // (Dòng này để bao quát trường hợp PostStatus không có trong DTO nhưng entity đã là closed/editing từ trước
            // và ta vẫn muốn đảm bảo JobSaved được dọn dẹp - tuy nhiên, logic này chặt chẽ hơn khi chỉ xét thay đổi từ DTO)
            // Ta sẽ tập trung vào trường hợp thay đổi do DTO.
            // Nếu chỉ muốn xóa khi DTO yêu cầu thay đổi sang closed/editing:
            if (postStatusChangedToInvalid) // Chính xác hơn là kiểm tra giá trị mới của entity.PostStatus
                                            // Hoặc, kiểm tra trạng thái cuối cùng của entity.PostStatus trước khi SaveChanges:
                                            // if (entity.PostStatus == "closed" || entity.PostStatus == "editing")
            {
                // Nếu entity.PostStatus được set thành "closed" hoặc "editing" từ dto
                // Hoặc nếu bạn muốn nó luôn kiểm tra trạng thái cuối cùng của entity.PostStatus trước khi lưu:
                if (entity.PostStatus == "closed" || entity.PostStatus == "editing")
                {
                    var savedJobsToRemove = await _context.JobSaveds
                        .Where(js => js.IdJobPost == id)
                        .ToListAsync();

                    if (savedJobsToRemove.Any())
                    {
                        _context.JobSaveds.RemoveRange(savedJobsToRemove);
                        _logger.LogInformation($"Đã xóa {savedJobsToRemove.Count} JobSaved cho JobPosting ID: {id} do trạng thái được cập nhật thành '{entity.PostStatus}'.");
                    }
                }
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // =========================================================================
        // DELETE: api/jobposting/{id}
        // =========================================================================
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            // Optional: Kiểm tra quyền
            var jobPosting = await _context.JobPostings.FindAsync(id);
            if (jobPosting == null)
            {
                return NotFound(new { message = "Không tìm thấy tin tuyển dụng." });
            }
            _context.JobPostings.Remove(jobPosting);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // =========================================================================
        // PATCH: api/jobposting/{id}/status
        // =========================================================================
        [HttpPatch("{id}/status")]
        public async Task<IActionResult> UpdateStatus(string id, [FromBody] UpdateStatusDto dto) // Đảm bảo UpdateStatusDto được định nghĩa
        {
            if (dto == null || string.IsNullOrWhiteSpace(dto.Status))
            {
                return BadRequest(new { message = "Trường 'status' là bắt buộc." });
            }
            // Validate giá trị của status nếu cần
            var validStatuses = new[] { "open", "closed", "waiting", "editing" };
            if (!validStatuses.Contains(dto.Status.ToLower()))
            {
                return BadRequest(new { message = $"Giá trị status không hợp lệ. Chỉ chấp nhận: {string.Join(", ", validStatuses)}" });
            }

            var job = await _context.JobPostings.FindAsync(id);
            if (job == null)
            {
                return NotFound(new { message = "Không tìm thấy tin tuyển dụng." });
            }

            job.PostStatus = dto.Status;
            job.UpdatedAt = DateTime.UtcNow;

            // Chỉ đánh dấu các thuộc tính bị thay đổi
            _context.Entry(job).Property(j => j.PostStatus).IsModified = true;
            _context.Entry(job).Property(j => j.UpdatedAt).IsModified = true;

            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

    // Cần định nghĩa UpdateStatusDto (ví dụ, trong file DTOs/JobPostingDto.cs)
    // public class UpdateStatusDto
    // {
    //     [Required]
    //     public string Status { get; set; }
    // }
}