// Program.cs
using Microsoft.EntityFrameworkCore;
using ExoticBirdsAPI.Data;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Configure the database context to use SQLite with a connection string from configuration.
builder.Services.AddDbContext<BirdContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("BirdDatabase")));

// Add Swagger/OpenAPI configuration
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Exotic Birds API",
        Version = "v1",
        Description = "An API to manage information about exotic birds, including Base64-encoded images.",
        Contact = new OpenApiContact
        {
            Name = "API Support",
            Email = "support@example.com" // Optional contact info
        }
    });
});

var app = builder.Build();

// Seed the database (optional) if it's empty
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<BirdContext>();
    dbContext.Database.EnsureCreated();
    SeedData.Initialize(dbContext);
}

// Configure middleware
if (app.Environment.IsDevelopment())
{
    // Enable Swagger only in development mode
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Exotic Birds API v1");
        c.RoutePrefix = string.Empty; // Set Swagger UI at the root
    });
}

app.UseAuthorization();

// Map controllers to handle API requests
app.MapControllers();

app.Run();
