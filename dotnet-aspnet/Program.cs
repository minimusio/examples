var builder = WebApplication.CreateBuilder(args);

// Add services to the container (if needed)
// builder.Services.AddControllers(); // Uncomment for Web API

var app = builder.Build();

// Configure the HTTP request pipeline
app.MapGet("/", () => "Hello from ASP.NET Core built by Minimus!");

// Run the app
app.Run();