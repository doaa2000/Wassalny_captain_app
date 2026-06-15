import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/captain_model.dart';
import 'auth_remote_data_source.dart';

/// Supabase-backed authentication. The only auth file aware of Supabase.
class AuthSupabaseDataSource implements AuthRemoteDataSource {
  const AuthSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<CaptainModel> login({required String phone, required String password}) async {
    try {
      // Email-based auth: the `phone` argument carries the login identifier
      // (the captain's email). Phone+password needs a paid SMS provider, so we
      // use email until that's configured.
      final sb.AuthResponse res =
          await _service.client.auth.signInWithPassword(email: phone, password: password);
      return _profileFor(res.user?.id);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> register({
    required String name,
    required String nationalId,
    required String licenseNumber,
    required String phone,
  }) async {
    try {
      // Phone-based onboarding: send the OTP so the app can continue to the
      // verification screen. The captain's profile is auto-created by the
      // `handle_new_user` trigger on first sign-in; the driver/vehicle row and
      // KYC documents are completed afterwards (admin reviews + approves).
      await _service.client.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> requestOtp(String phone) async {
    try {
      await _service.client.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CaptainModel> verifyOtp({required String phone, required String code}) async {
    try {
      final sb.AuthResponse res = await _service.client.auth.verifyOTP(
        phone: phone,
        token: code,
        type: sb.OtpType.sms,
      );
      return _profileFor(res.user?.id);
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> requestPasswordReset(String phone) async {
    try {
      await _service.client.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _service.client.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CaptainModel?> currentCaptain() async {
    final String? id = _service.currentUserId;
    if (id == null) return null;
    return _profileFor(id);
  }

  Future<CaptainModel> _profileFor(String? userId) async {
    if (userId == null) throw const AuthException('No active session.');
    final Map<String, dynamic> profile = await _service.client
        .from(AppConstants.tableProfiles)
        .select('id, full_name, phone')
        .eq('id', userId)
        .single();
    final Map<String, dynamic>? driver = await _service.client
        .from(AppConstants.tableDrivers)
        .select('rating')
        .eq('profile_id', userId)
        .maybeSingle();
    return CaptainModel.fromJson({
      'id': profile['id'],
      'name': profile['full_name'],
      'phone': profile['phone'],
      'rating': driver?['rating']?.toString(),
    });
  }
}
