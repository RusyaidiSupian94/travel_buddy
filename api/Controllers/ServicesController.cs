using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.Data;

namespace TravelBuddy.Api.Controllers;

[ApiController]
[Route("api/services")]
public class ServicesController : ControllerBase
{
    private readonly TravelBuddyDbContext _database;

    public ServicesController(TravelBuddyDbContext database)
    {
        _database = database;
    }

    [HttpGet]
    public async Task<IActionResult> GetServices(
        [FromQuery] string? category,
        CancellationToken cancellationToken)
    {
        var query = _database.Services
            .AsNoTracking()
            .Where(service => service.IsActive);

        if (!string.IsNullOrWhiteSpace(category))
        {
            query = query.Where(service => service.Category == category);
        }

        var services = await query
            .OrderBy(service => service.Name)
            .Select(service => new
            {
                service.Id,
                service.Name,
                service.Category,
                service.Description,
                service.PricePerDay,
                service.VendorId
            })
            .ToListAsync(cancellationToken);

        return Ok(services);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetService(
        Guid id,
        CancellationToken cancellationToken)
    {
        var service = await _database.Services
            .AsNoTracking()
            .Where(item => item.Id == id && item.IsActive)
            .Select(item => new
            {
                item.Id,
                item.Name,
                item.Category,
                item.Description,
                item.PricePerDay,
                item.VendorId
            })
            .SingleOrDefaultAsync(cancellationToken);

        return service is null ? NotFound() : Ok(service);
    }
}
