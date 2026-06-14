import '../models/captain_model.dart';

/// Authentication backend contract. A REST implementation can replace the
/// Supabase one without affecting the repository or anything above it.
abstract interface class AuthRemoteDataSource {
  Future<CaptainModel> login({required String phone, required String password});
  Future<void> register({
    required String name,
    required String nationalId,
    required String licenseNumber,
    required String phone,
  });
  Future<void> requestOtp(String phone);
  Future<CaptainModel> verifyOtp({required String phone, required String code});
  Future<void> requestPasswordReset(String phone);
  Future<void> logout();
  Future<CaptainModel?> currentCaptain();
}
