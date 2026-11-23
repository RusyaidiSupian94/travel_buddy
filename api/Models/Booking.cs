namespace TravelBuddy.Api.Models;

public enum BookingStatus
{
    Pending,
    Confirmed,
    Completed,
    Cancelled
}

public class Booking
{
    public Guid Id { get; set; }
    public Guid CustomerId { get; set; }
    public Guid VendorId { get; set; }
    public Guid ServiceId { get; set; }
    public DateTime BookingDate { get; set; }
    public int GuestCount { get; set; }
    public decimal TotalAmount { get; set; }
    public BookingStatus Status { get; set; } = BookingStatus.Pending;
    public DateTime CreatedAtUtc { get; set; }
}
