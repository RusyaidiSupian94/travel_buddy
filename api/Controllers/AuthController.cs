using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TravelBuddy.Api.App.Auth;
using TravelBuddy.Api.Data;
using TravelBuddy.Api.Models;

namespace TravelBuddy.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly TravelBuddyDbContext _database;
    private readonly IConfiguration _configuration;
    private readonly IWebHostEnvironment _environment;

    public AuthController(
        TravelBuddyDbContext database,
        IConfiguration configuration,
        IWebHostEnvironment environment)
    {
        _database = database;
        _configuration = configuration;
        _environment = environment;
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

        if (!_environment.IsDevelopment() && role != AppRole.Customer)
        {
            return BadRequest(new
            {
                message = "Role privileged hanya boleh diberikan oleh admin."
            });
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

    private AuthResponse ToResponse(AppUser user)
    {
        var token = CreateAccessToken(user, out var expiresAtUtc);

        return new AuthResponse(
            user.Id,
            user.DisplayName,
            user.Email,
            user.Role.ToString(),
            token,
            expiresAtUtc,
            true);
    }

    private string CreateAccessToken(
        AppUser user,
        out DateTime expiresAtUtc)
    {
        var key = _configuration["Jwt:Key"];
        if (string.IsNullOrWhiteSpace(key))
        {
            throw new InvalidOperationException("Jwt:Key is not configured.");
        }

        var expiresMinutes = int.TryParse(
            _configuration["Jwt:ExpiresMinutes"],
            out var configuredMinutes)
            ? configuredMinutes
            : 60;

        expiresAtUtc = DateTime.UtcNow.AddMinutes(expiresMinutes);
        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.DisplayName),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Role, user.Role.ToString())
        };

        var signingKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(key));
        var credentials = new SigningCredentials(
            signingKey,
            SecurityAlgorithms.HmacSha256);
        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: expiresAtUtc,
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
