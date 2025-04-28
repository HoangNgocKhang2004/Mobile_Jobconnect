using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using HuitWorks.WebAPI.Data;

// DTO để nhận dữ liệu tạo Role
namespace HuitWorks.WebAPI.Models
{
    public class CreateRoleDto
    {
        [Required(ErrorMessage = "RoleName is required.")]
        [StringLength(50, ErrorMessage = "RoleName cannot be longer than 50 characters.")]
        public string RoleName { get; set; } = null!;

        [StringLength(200, ErrorMessage = "Description cannot be longer than 200 characters.")]
        public string? Description { get; set; }
    }

    // DTO để nhận dữ liệu cập nhật Role
    public class UpdateRoleDto
    {
        [Required(ErrorMessage = "RoleName is required.")]
        [StringLength(50, ErrorMessage = "RoleName cannot be longer than 50 characters.")]
        public string RoleName { get; set; } = null!;

        [StringLength(200, ErrorMessage = "Description cannot be longer than 200 characters.")]
        public string? Description { get; set; }
    }

    // DTO để trả về dữ liệu Role
    public class RoleDto
    {
        public string IdRole { get; set; } = null!;
        public string RoleName { get; set; } = null!;
        public string? Description { get; set; }
    }
}