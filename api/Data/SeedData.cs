using Microsoft.EntityFrameworkCore;
using TravelBuddy.Api.App.Auth;
using TravelBuddy.Api.Models;

namespace TravelBuddy.Api.Data;

public static class SeedData
{
    private static readonly Guid CustomerId =
        Guid.Parse("11111111-1111-1111-1111-111111111111");

    private static readonly Guid VendorId =
        Guid.Parse("22222222-2222-2222-2222-222222222222");

    private static readonly Guid AdminId =
        Guid.Parse("33333333-3333-3333-3333-333333333333");

    private static readonly Guid SuperadminId =
        Guid.Parse("44444444-4444-4444-4444-444444444444");

    private static readonly Guid IslandGuideId =
        Guid.Parse("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa");

    private static readonly Guid IslandHoppingId =
        Guid.Parse("bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb");

    private static readonly Guid BookingId =
        Guid.Parse("cccccccc-cccc-cccc-cccc-cccccccccccc");

    public static async Task InitializeAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var environment = scope.ServiceProvider
            .GetRequiredService<IHostEnvironment>();

        if (!environment.IsDevelopment())
        {
            return;
        }

        var database = scope.ServiceProvider
            .GetRequiredService<TravelBuddyDbContext>();

        await database.Database.EnsureCreatedAsync();

        var now = DateTime.UtcNow;
        var customer = await EnsureUserAsync(
            database,
            CustomerId,
            "Aina Customer",
            "customer@travelbuddy.test",
            AppRole.Customer,
            now);
        var vendor = await EnsureUserAsync(
            database,
            VendorId,
            "Ahmad Vendor",
            "vendor@travelbuddy.test",
            AppRole.Vendor,
            now);

        await EnsureUserAsync(
            database,
            AdminId,
            "Mia Admin",
            "admin@travelbuddy.test",
            AppRole.Admin,
            now);
        await EnsureUserAsync(
            database,
            SuperadminId,
            "TravelBuddy Superadmin",
            "superadmin@travelbuddy.test",
            AppRole.Superadmin,
            now);

        var islandGuide = await EnsureServiceAsync(
            database,
            IslandGuideId,
            vendor.Id,
            "Private island guide",
            "Guide",
            "Local guide untuk pengalaman private di Langkawi.",
            250m,
            now);
        await EnsureServiceAsync(
            database,
            IslandHoppingId,
            vendor.Id,
            "Langkawi island hopping",
            "Itinerary",
            "Island hopping dengan pickup yang dipersetujui.",
            340m,
            now);

        if (!await database.Bookings.AnyAsync(booking => booking.Id == BookingId))
        {
            database.Bookings.Add(new Booking
            {
                Id = BookingId,
                CustomerId = customer.Id,
                VendorId = vendor.Id,
                ServiceId = islandGuide.Id,
                BookingDate = now.Date.AddDays(7),
                GuestCount = 2,
                TotalAmount = 525m,
                Status = BookingStatus.Confirmed,
                CreatedAtUtc = now
            });
        }

        await database.SaveChangesAsync();
    }

    private static async Task<AppUser> EnsureUserAsync(
        TravelBuddyDbContext database,
        Guid preferredId,
        string displayName,
        string email,
        AppRole role,
        DateTime createdAtUtc)
    {
        var existingUser = await database.Users
            .SingleOrDefaultAsync(user =>
                user.Id == preferredId || user.Email == email);

        if (existingUser is not null)
        {
            if (string.IsNullOrWhiteSpace(existingUser.PasswordHash))
            {
                existingUser.PasswordHash = PasswordHasher.Hash("password");
            }

            return existingUser;
        }

        var user = new AppUser
        {
            Id = preferredId,
            DisplayName = displayName,
            Email = email,
            Role = role,
            PasswordHash = PasswordHasher.Hash("password"),
            CreatedAtUtc = createdAtUtc
        };

        database.Users.Add(user);
        return user;
    }

    private static async Task<TravelService> EnsureServiceAsync(
        TravelBuddyDbContext database,
        Guid preferredId,
        Guid vendorId,
        string name,
        string category,
        string description,
        decimal pricePerDay,
        DateTime createdAtUtc)
    {
        var existingService = await database.Services
            .SingleOrDefaultAsync(service => service.Id == preferredId);

        if (existingService is not null)
        {
            return existingService;
        }

        var service = new TravelService
        {
            Id = preferredId,
            VendorId = vendorId,
            Name = name,
            Category = category,
            Description = description,
            PricePerDay = pricePerDay,
            IsActive = true,
            CreatedAtUtc = createdAtUtc
        };

        database.Services.Add(service);
        return service;
    }
}
