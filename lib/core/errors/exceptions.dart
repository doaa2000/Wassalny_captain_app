/// Low-level exceptions thrown by the data layer (data sources). They are
/// caught inside repository implementations and converted into [Failure]s so
/// that the domain/presentation layers never depend on data-layer details.
class ServerException implements Exception {
  const ServerException([this.message = 'Unexpected server error']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'Authentication failed']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

/// Thrown when a valid auth session exists but the captain's driver record is
/// gone (e.g. an admin removed them) — they are no longer an active captain.
class CaptainRemovedException implements Exception {
  const CaptainRemovedException(
      [this.message = 'This captain account is no longer active.']);
  final String message;
}
