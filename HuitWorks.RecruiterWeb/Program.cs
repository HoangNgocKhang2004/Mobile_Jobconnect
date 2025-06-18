using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Google.Cloud.Storage.V1;
using HuitWorks.RecruiterWeb.Service;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Net.Http.Headers;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

string bucketName = builder.Configuration["Firebase:StorageBucket"];
if (string.IsNullOrEmpty(bucketName))
{
    throw new InvalidOperationException("Thiếu cấu hình StorageBucket trong appsettings.json");
}

string relativeJsonPath = builder.Configuration["Firebase:ServiceAccountJsonPath"];
if (string.IsNullOrEmpty(relativeJsonPath))
{
    throw new InvalidOperationException("Thiếu cấu hình ServiceAccountJsonPath trong appsettings.json");
}


string absoluteJsonPath = Path.Combine(builder.Environment.ContentRootPath, relativeJsonPath);

if (!File.Exists(absoluteJsonPath))
{
    throw new FileNotFoundException($"Không tìm thấy file Service Account JSON tại: {absoluteJsonPath}");
}

if (FirebaseApp.DefaultInstance is null)
{
    FirebaseApp.Create(new AppOptions()
    {
        Credential = GoogleCredential.FromFile(absoluteJsonPath)
    });
}

GoogleCredential storageCredential = GoogleCredential
    .FromFile(absoluteJsonPath)
    .CreateScoped("https://www.googleapis.com/auth/cloud-platform");

StorageClient storageClient = StorageClient.Create(storageCredential);
builder.Services.AddSingleton(storageClient);
builder.Services.AddSingleton(bucketName);

builder.Services.AddControllersWithViews(options =>
{
    var policy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .Build();
    options.Filters.Add(new AuthorizeFilter(policy));
});

builder.Services
    .AddControllers()
    .AddJsonOptions(opts =>
    {
        opts.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    });

builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));
builder.Services.AddScoped<IEmailService, EmailService>();

builder.Services.AddHttpClient("ApiClient", client =>
{
    client.BaseAddress = new Uri("http://localhost:5281/");
    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
})
.ConfigurePrimaryHttpMessageHandler(() =>
{
    var handler = new HttpClientHandler();
    handler.ServerCertificateCustomValidationCallback =
        HttpClientHandler.DangerousAcceptAnyServerCertificateValidator;
    return handler;
});

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IQuotaService, QuotaService>();

builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "HuitRecruiter.Cookie";
        options.Cookie.HttpOnly = true;
        options.Cookie.SameSite = SameSiteMode.None;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.LoginPath = "/Auth/Login";
        options.AccessDeniedPath = "/Auth/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromMinutes(30);
    });

builder.Services.AddAuthorization();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
app.UseSession();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Auth}/{action=Login}/{id?}");

app.Run();