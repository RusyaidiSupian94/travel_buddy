namespace TravelBuddy.Api.Models;

public class TravelService
{
    public Guid Id { get; set; }
    public Guid VendorId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Category { get; set; } = "Guide";
    public string Description { get; set; } = string.Empty;
    public decimal PricePerDay { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAtUtc { get; set; }
}
