using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<TravelBuddyDbContext>(options =>
    options.UseSqlite(
        builder.Configuration.GetConnectionString("TravelBuddy")));

builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterClient", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("FlutterClient");

if (!app.Environment.IsDevelopment())
{
    app.UseHttpsRedirection();
}

app.MapControllers();

await SeedData.InitializeAsync(app.Services);

app.Run();
