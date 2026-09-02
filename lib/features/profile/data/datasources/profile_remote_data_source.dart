import '../../domain/entities/captain_profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<CaptainProfile> fetchProfile();
  Future<CaptainProfile> updateProfile({
    required String name,
    required String phone,
  });
}

/// In-memory profile seeded from the design.
class ProfileLocalDataSource implements ProfileRemoteDataSource {
  CaptainProfile _profile = const CaptainProfile(
    name: 'Tarek Mahmoud',
    initials: 'TM',
    memberSince: 'Captain since 2021',
    rating: '4.92',
    ratingLabel: '4.92 · Top rated',
    totalTrips: '3,847',
    acceptanceRate: '94%',
    completionRate: '99%',
  );

  @override
  Future<CaptainProfile> fetchProfile() async => _profile;

  @override
  Future<CaptainProfile> updateProfile({
    required String name,
    required String phone,
  }) async {
    _profile = CaptainProfile(
      name: name,
      initials: _initialsOf(name),
      memberSince: _profile.memberSince,
      rating: _profile.rating,
      ratingLabel: _profile.ratingLabel,
      totalTrips: _profile.totalTrips,
      acceptanceRate: _profile.acceptanceRate,
      completionRate: _profile.completionRate,
    );
    return _profile;
  }

  static String _initialsOf(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
