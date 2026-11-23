using TravelBuddy.Api.Models;

namespace TravelBuddy.Api.App.Auth;

public sealed record LoginRequest(
    string Email,
    string Password);

public sealed record RegisterRequest(
    string DisplayName,
    string Email,
    string Password,
    string ConfirmPassword,
    string Role);

public sealed record AuthResponse(
    Guid UserId,
    string DisplayName,
    string Email,
    string Role,
    string AccessToken,
    DateTime ExpiresAtUtc,
    bool IsDemo);
