using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TravelBuddy.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/dashboard")]
public class DashboardController : ControllerBase
{
    [HttpGet("vendor")]
    [Authorize(Roles = "Vendor")]
    public IActionResult Vendor()
    {
        return Ok(CreateResponse("Vendor"));
    }

    [HttpGet("admin")]
    [Authorize(Roles = "Admin")]
    public IActionResult Admin()
    {
        return Ok(CreateResponse("Admin"));
    }

    [HttpGet("superadmin")]
    [Authorize(Roles = "Superadmin")]
    public IActionResult Superadmin()
    {
        return Ok(CreateResponse("Superadmin"));
    }

    private object CreateResponse(string role)
    {
        return new
        {
            role,
            userId = User.FindFirstValue(ClaimTypes.NameIdentifier),
            displayName = User.Identity?.Name,
            message = $"{role} dashboard access granted."
        };
    }
}
