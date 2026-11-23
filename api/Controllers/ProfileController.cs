using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.Data;

namespace TravelBuddy.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/profile")]
public class ProfileController : ControllerBase
{
    private readonly TravelBuddyDbContext _database;

    public ProfileController(TravelBuddyDbContext database)
    {
        _database = database;
    }

    [HttpGet("me")]
    public async Task<IActionResult> GetCurrentProfile(
        CancellationToken cancellationToken)
    {
        var rawUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!Guid.TryParse(rawUserId, out var userId))
        {
            return Unauthorized();
        }

        var user = await _database.Users
            .AsNoTracking()
            .Where(item => item.Id == userId)
            .Select(item => new
            {
                item.Id,
                item.DisplayName,
                item.Email,
                Role = item.Role.ToString()
            })
            .SingleOrDefaultAsync(cancellationToken);

        return user is null ? NotFound() : Ok(user);
    }
}
