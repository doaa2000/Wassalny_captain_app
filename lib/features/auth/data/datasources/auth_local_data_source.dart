import 'dart:typed_data';

import '../models/captain_model.dart';
import 'auth_remote_data_source.dart';

/// In-memory auth used for credential-less local development. Accepts any
/// input and returns the demo captain from the design.
class AuthLocalDataSource implements AuthRemoteDataSource {
  static const CaptainModel _demoCaptain = CaptainModel(
    id: 'demo-captain',
    name: 'Tarek Mahmoud',
    phone: '+20 106 884 2190',
    initials: 'TM',
    rating: '4.92',
    memberSince: 'Captain since 2021',
    approvalStatus: 'approved',
  );

  @override
  Future<CaptainModel> login({required String phone, required String password}) async => _demoCaptain;

  @override
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
  }) async =>
      _demoCaptain;

  @override
  Future<void> requestOtp(String phone) async {}

  @override
  Future<CaptainModel> verifyOtp({required String phone, required String code}) async => _demoCaptain;

  @override
  Future<void> requestPasswordReset(String phone) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<CaptainModel?> currentCaptain() async => null;
}
