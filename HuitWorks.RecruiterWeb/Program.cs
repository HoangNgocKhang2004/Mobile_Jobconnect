var builder = WebApplication.CreateBuilder(args);

// Cấu hình bộ nhớ đệm cho Session
builder.Services.AddDistributedMemoryCache();

// Bật Session
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30); // Session sẽ hết hạn sau 30 phút không hoạt động
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Middleware xử lý lỗi
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// ⚠️ Phải đặt `UseSession` trước `UseAuthorization`
app.UseSession();
app.UseAuthorization();

// Route mặc định chuyển đến trang Login
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Auth}/{action=Login}/{id?}");

app.Run();
