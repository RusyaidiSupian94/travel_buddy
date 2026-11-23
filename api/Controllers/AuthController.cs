using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.App.Auth;
using TravelBuddy.Api.Data;
using TravelBuddy.Api.Models;

namespace TravelBuddy.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly TravelBuddyDbContext _database;

    public AuthController(TravelBuddyDbContext database)
    {
        _database = database;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.Email) ||
            string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new { message = "Email dan password diperlukan." });
        }

        var email = request.Email.Trim().ToLowerInvariant();
        var user = await _database.Users
            .SingleOrDefaultAsync(item => item.Email == email, cancellationToken);

        if (user is null ||
            !PasswordHasher.Verify(request.Password, user.PasswordHash))
        {
            return Unauthorized(new { message = "Email atau password tidak sah." });
        }

        return Ok(ToResponse(user));
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(
        [FromBody] RegisterRequest request,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.DisplayName) ||
            string.IsNullOrWhiteSpace(request.Email) ||
            request.Password.Length < 6)
        {
            return BadRequest(new
            {
                message = "Nama, email dan password minimum 6 aksara diperlukan."
            });
        }

        if (request.Password != request.ConfirmPassword)
        {
            return BadRequest(new { message = "Password tidak sepadan." });
        }

        if (!Enum.TryParse<AppRole>(request.Role, true, out var role))
        {
            return BadRequest(new { message = "Role tidak sah." });
        }

        var email = request.Email.Trim().ToLowerInvariant();
        var existingUser = await _database.Users
            .AnyAsync(item => item.Email == email, cancellationToken);

        if (existingUser)
        {
            return Conflict(new { message = "Email telah digunakan." });
        }

        var user = new AppUser
        {
            Id = Guid.NewGuid(),
            DisplayName = request.DisplayName.Trim(),
            Email = email,
            Role = role,
            PasswordHash = PasswordHasher.Hash(request.Password),
            CreatedAtUtc = DateTime.UtcNow
        };

        _database.Users.Add(user);
        await _database.SaveChangesAsync(cancellationToken);

        return Created(string.Empty, ToResponse(user));
    }

    private static AuthResponse ToResponse(AppUser user)
    {
        return new AuthResponse(
            user.Id,
            user.DisplayName,
            user.Email,
            user.Role.ToString(),
            true);
    }
}
