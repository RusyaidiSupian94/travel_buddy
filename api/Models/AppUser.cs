namespace TravelBuddy.Api.Models;

public enum AppRole
{
    Customer,
    Vendor,
    Admin,
    Superadmin
}

public class AppUser
{
    public Guid Id { get; set; }
    public string DisplayName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public AppRole Role { get; set; } = AppRole.Customer;
    public string PasswordHash { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; }
}