import '../../domain/entities/captain_profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<CaptainProfile> fetchProfile();
}

/// In-memory profile seeded from the design.
class ProfileLocalDataSource implements ProfileRemoteDataSource {
  @override
  Future<CaptainProfile> fetchProfile() async => const CaptainProfile(
        name: 'Tarek Mahmoud',
        initials: 'TM',
        memberSince: 'Captain since 2021',
        rating: '4.92',
        ratingLabel: '4.92 · Top rated',
        totalTrips: '3,847',
        acceptanceRate: '94%',
        completionRate: '99%',
      );
}
