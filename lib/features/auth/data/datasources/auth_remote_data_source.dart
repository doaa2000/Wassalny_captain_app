import 'dart:typed_data';

import '../models/captain_model.dart';

/// Authentication backend contract. A REST implementation can replace the
/// Supabase one without affecting the repository or anything above it.
abstract interface class AuthRemoteDataSource {
  Future<CaptainModel> login({required String phone, required String password});

  /// Creates the captain's account (email + password — the same mechanism
  /// as [login], so a captain who registers can always log back in), the
  /// `drivers` row (vehicle/KYC info, defaults to `approval_status: pending`
  /// server-side), and uploads each KYC document. [documents] maps a
  /// document type (e.g. `'driver_license'`) to its image bytes.
  Future<CaptainModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String nationalId,
    required String licenseNumber,
    required String vehicleModel,
    required int vehicleYear,
    required String plateNumber,
    required Map<String, Uint8List> documents,
  });

  Future<void> requestOtp(String phone);
  Future<CaptainModel> verifyOtp({required String phone, required String code});
  Future<void> requestPasswordReset(String phone);
  Future<void> logout();
  Future<CaptainModel?> currentCaptain();
}
