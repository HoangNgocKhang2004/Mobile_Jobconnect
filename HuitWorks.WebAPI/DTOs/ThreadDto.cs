namespace HuitWorks.WebAPI.DTOs
{
    public class ThreadDto
    {
        public string? IdThread { get; set; }
        public string? IdUser1 { get; set; }
        public string? IdUser2 { get; set; }
        public DateTime CreatedAt { get; set; }
    }
    public class CreateThreadDto
    {
        public string? IdUser1 { get; set; }
        public string? IdUser2 { get; set; }
    }
}
