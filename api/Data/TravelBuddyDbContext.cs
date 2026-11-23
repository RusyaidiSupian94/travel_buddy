using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.Models;

namespace TravelBuddy.Api.Data;

public class TravelBuddyDbContext : DbContext
{
    public TravelBuddyDbContext(
        DbContextOptions<TravelBuddyDbContext> options)
        : base(options)
    {
    }

    public DbSet<AppUser> Users => Set<AppUser>();
    public DbSet<TravelService> Services => Set<TravelService>();
    public DbSet<Booking> Bookings => Set<Booking>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AppUser>()
            .HasIndex(user => user.Email)
            .IsUnique();

        modelBuilder.Entity<TravelService>()
            .HasOne<AppUser>()
            .WithMany()
            .HasForeignKey(service => service.VendorId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Booking>()
            .HasOne<AppUser>()
            .WithMany()
            .HasForeignKey(booking => booking.CustomerId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Booking>()
            .HasOne<AppUser>()
            .WithMany()
            .HasForeignKey(booking => booking.VendorId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Booking>()
            .HasOne<TravelService>()
            .WithMany()
            .HasForeignKey(booking => booking.ServiceId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<TravelService>()
            .Property(service => service.PricePerDay)
            .HasPrecision(18, 2);

        modelBuilder.Entity<Booking>()
            .Property(booking => booking.TotalAmount)
            .HasPrecision(18, 2);
    }
}
