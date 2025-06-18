using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;

namespace YourApp.Controllers
{
    [ApiController]
    [Route("api/chat/threads")]
    public class ChatController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public ChatController(JobConnectDbContext context)
        {
            _context = context;
        }

        // 1. Tạo mới một thread (1-1)
        [HttpPost]
        public async Task<ActionResult<ThreadDto>> CreateThread([FromBody] CreateThreadDto dto)
        {
            if (dto.IdUser1 == dto.IdUser2)
                return BadRequest("Không thể tạo cuộc chat với chính mình.");

            var user1 = await _context.Users.FindAsync(dto.IdUser1);
            var user2 = await _context.Users.FindAsync(dto.IdUser2);

            if (user1 == null || user2 == null)
                return NotFound("One or both users do not exist.");

            var thread = new ChatThread
            {
                IdThread = Guid.NewGuid().ToString(),
                IdUser1 = dto.IdUser1,
                IdUser2 = dto.IdUser2,
                CreatedAt = DateTime.UtcNow,
                User1 = user1, 
                User2 = user2  
            };

            _context.ChatThreads.Add(thread);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetMessages),
                                   new { threadId = thread.IdThread },
                                   new ThreadDto
                                   {
                                       IdThread = thread.IdThread,
                                       IdUser1 = thread.IdUser1,
                                       IdUser2 = thread.IdUser2,
                                       CreatedAt = thread.CreatedAt
                                   });
        }

        // 2. Lấy tất cả threads mà user tham gia
        //    GET api/chat/threads?userId=...
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ThreadDto>>> GetThreads([FromQuery] string userId)
        {
            var threads = await _context.ChatThreads
                .Where(t => t.IdUser1 == userId || t.IdUser2 == userId)
                .Select(t => new ThreadDto
                {
                    IdThread = t.IdThread,
                    IdUser1 = t.IdUser1,
                    IdUser2 = t.IdUser2,
                    CreatedAt = t.CreatedAt
                })
                .ToListAsync();

            return Ok(threads);
        }

        // 3. Gửi tin nhắn vào thread
        //    POST api/chat/threads/{threadId}/messages
        [HttpPost("{threadId}/messages")]
        public async Task<ActionResult<MessageDto>> SendMessage(
            string threadId,
            [FromBody] SendMessageDto dto)
        {
            // Kiểm tra thread tồn tại
            var thread = await _context.ChatThreads
                .Include(t => t.User1)
                .Include(t => t.User2)
                .FirstOrDefaultAsync(t => t.IdThread == threadId);

            if (thread == null)
                return NotFound("Thread không tồn tại.");

            var sender = await _context.Users.FindAsync(dto.IdSender);
            if (sender == null)
                return NotFound("Người gửi không tồn tại.");

            var msg = new Message
            {
                IdMessage = Guid.NewGuid().ToString(),
                IdThread = threadId,
                IdSender = dto.IdSender,
                Content = dto.Content,
                SentAt = DateTime.Now,
                IsRead = false,
                Thread = thread,
                Sender = sender
            };

            _context.Messages.Add(msg);
            await _context.SaveChangesAsync();

            return Ok(new MessageDto
            {
                IdMessage = msg.IdMessage,
                IdThread = msg.IdThread,
                IdSender = msg.IdSender,
                Content = msg.Content,
                SentAt = msg.SentAt,
                IsRead = msg.IsRead
            });
        }

        // 4. Lấy toàn bộ tin nhắn trong thread
        //    GET api/chat/threads/{threadId}/messages
        [HttpGet("{threadId}/messages")]
        public async Task<ActionResult<IEnumerable<MessageDto>>> GetMessages(string threadId)
        {
            var msgs = await _context.Messages
                .Where(m => m.IdThread == threadId)
                .OrderBy(m => m.SentAt)
                .Select(m => new MessageDto
                {
                    IdMessage = m.IdMessage,
                    IdThread = m.IdThread,
                    IdSender = m.IdSender,
                    Content = m.Content,
                    SentAt = m.SentAt,
                    IsRead = m.IsRead
                })
                .ToListAsync();

            return Ok(msgs);
        }

        // 5. Đánh dấu tin nhắn đã đọc
        //    PUT api/chat/threads/{threadId}/messages/{messageId}/read
        [HttpPut("{threadId}/messages/{messageId}/read")]
        public async Task<IActionResult> MarkAsRead(string threadId, string messageId)
        {
            var msg = await _context.Messages.FindAsync(messageId);
            if (msg == null || msg.IdThread != threadId)
                return NotFound();

            msg.IsRead = true;
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
