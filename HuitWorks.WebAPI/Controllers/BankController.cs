using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using HuitWorks.WebAPI.DTOs;

namespace HuitWorks.WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BankController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public BankController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/bank
        [HttpGet]
        public async Task<ActionResult<IEnumerable<BankDto>>> GetBanks()
        {
            var banks = await _context.Bank
                .Select(b => new BankDto
                {
                    BankId = b.BankId,
                    BankName = b.BankName,
                    BankCode = b.BankCode,
                    Balance = b.Balance,
                    CardNumber = b.CardNumber,
                    AccountType = b.AccountType,
                    CardType = b.CardType,
                    IsDefault = b.IsDefault,
                    ImageUrl = b.ImageUrl,
                    UserId = b.UserId
                })
                .ToListAsync();

            return Ok(banks);
        }

        // GET: api/bank/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<BankDto>> GetBank(string id)
        {
            var bank = await _context.Bank.FindAsync(id);
            if (bank == null)
                return NotFound(new { message = "Bank record not found." });

            var dto = new BankDto
            {
                BankId = bank.BankId,
                BankName = bank.BankName,
                BankCode = bank.BankCode,
                Balance = bank.Balance,
                CardNumber = bank.CardNumber,
                AccountType = bank.AccountType,
                CardType = bank.CardType,
                IsDefault = bank.IsDefault,
                ImageUrl = bank.ImageUrl,
                UserId = bank.UserId
            };

            return Ok(dto);
        }

        // POST: api/bank
        [HttpPost]
        public async Task<ActionResult<BankDto>> CreateBank(CreateBankDto dto)
        {
            var userExists = await _context.Users.AnyAsync(u => u.IdUser == dto.UserId);
            if (!userExists)
                return BadRequest(new { message = "UserId không tồn tại." });

            var bank = new Bank
            {
                BankId = Guid.NewGuid().ToString(),
                BankName = dto.BankName,
                BankCode = dto.BankCode,
                Balance = dto.Balance,
                CardNumber = dto.CardNumber,
                AccountType = dto.AccountType,
                CardType = dto.CardType,
                IsDefault = dto.IsDefault,
                ImageUrl = dto.ImageUrl,
                UserId = dto.UserId
            };

            _context.Bank.Add(bank);
            await _context.SaveChangesAsync();

            var createdDto = new BankDto
            {
                BankId = bank.BankId,
                BankName = bank.BankName,
                BankCode = bank.BankCode,
                Balance = bank.Balance,
                CardNumber = bank.CardNumber,
                AccountType = bank.AccountType,
                CardType = bank.CardType,
                IsDefault = bank.IsDefault,
                ImageUrl = bank.ImageUrl,
                UserId = bank.UserId
            };

            return CreatedAtAction(nameof(GetBank), new { id = bank.BankId }, createdDto);
        }

        // PUT: api/bank/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateBank(string id, UpdateBankDto dto)
        {
            var bank = await _context.Bank.FindAsync(id);
            if (bank == null)
                return NotFound(new { message = "Bank record not found." });

            // Chỉ cập nhật những trường có dữ liệu mới
            bank.BankName = dto.BankName ?? bank.BankName;
            bank.BankCode = dto.BankCode ?? bank.BankCode;
            bank.Balance = dto.Balance ?? bank.Balance;
            bank.CardNumber = dto.CardNumber ?? bank.CardNumber;
            bank.AccountType = dto.AccountType ?? bank.AccountType;
            bank.CardType = dto.CardType ?? bank.CardType;
            bank.IsDefault = dto.IsDefault;
            bank.ImageUrl = dto.ImageUrl ?? bank.ImageUrl;

            _context.Bank.Update(bank);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/bank/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBank(string id)
        {
            var bank = await _context.Bank.FindAsync(id);
            if (bank == null)
                return NotFound(new { message = "Bank record not found." });

            _context.Bank.Remove(bank);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/bank/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<BankDto>>> GetBanksByUser(string userId)
        {
            var userExists = await _context.Users.AnyAsync(u => u.IdUser == userId);
            if (!userExists)
                return NotFound(new { message = "User không tồn tại." });

            var banks = await _context.Bank
                .Where(b => b.UserId == userId)
                .Select(b => new BankDto
                {
                    BankId = b.BankId,
                    BankName = b.BankName,
                    BankCode = b.BankCode,
                    Balance = b.Balance,
                    CardNumber = b.CardNumber,
                    AccountType = b.AccountType,
                    CardType = b.CardType,
                    IsDefault = b.IsDefault,
                    ImageUrl = b.ImageUrl,
                    UserId = b.UserId
                })
                .ToListAsync();

            return Ok(banks);
        }

        // PUT: api/bank/{id}/balance
        [HttpPut("{id}/balance")]
        public async Task<IActionResult> UpdateBalance(string id, [FromBody] UpdateBalanceDto dto)
        {
            var bank = await _context.Bank.FindAsync(id);
            if (bank == null)
                return NotFound(new { message = "Bank record not found." });

            bank.Balance = dto.Balance;

            _context.Bank.Update(bank);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Balance updated successfully." });
        }

    }
}
