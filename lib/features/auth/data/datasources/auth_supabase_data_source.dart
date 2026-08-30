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
  Future<CaptainModel> login(
      {required String phone, required String password}) async {
    try {
      // Email-based auth: the `phone` argument carries the login identifier
      // (the captain's email). Phone+password needs a paid SMS provider, so we
      // use email until that's configured.
      final sb.AuthResponse res = await _service.client.auth
          .signInWithPassword(email: phone, password: password);
      return await _profileFor(res.user?.id, requireDriver: true);
    } on CaptainRemovedException {
      // Credentials were valid (a session was created) but the captain has no
      // driver record — sign back out so no dangling session remains.
      await _service.client.auth.signOut();
      rethrow;
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> register({
 required String   name,
    required String email,
    required String password,
    required String nationalId,
   required String  licenseNumber,
  }) async {
    try {
      // Phone-based onboarding: send the OTP so the app can continue to the
      // verification screen. The captain's profile is auto-created by the
      // `handle_new_user` trigger on first sign-in; the driver/vehicle row and
      // KYC documents are completed afterwards (admin reviews + approves).
      await _service.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'role': 'driver',
        },
      );
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
  Future<CaptainModel> verifyOtp(
      {required String phone, required String code}) async {
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
    // Base the decision on the persisted auth session, NOT on a successful
    // profile fetch — otherwise a transient/RLS/offline error on launch would
    // wrongly sign the captain out and force a re-login every time.
    final sb.User? user = _service.client.auth.currentUser;
    if (user == null) return null;
    try {
      final Map<String, dynamic>? profile = await _service.client
          .from(AppConstants.tableProfiles)
          .select('id, full_name, phone')
          .eq('id', user.id)
          .maybeSingle();
      final Map<String, dynamic>? driver = await _service.client
          .from(AppConstants.tableDrivers)
          .select('rating')
          .eq('profile_id', user.id)
          .maybeSingle();
      // The auth account is fine, but the driver record is gone → an admin
      // removed this captain. Signal it so the app shows the removed screen.
      if (driver == null) throw const CaptainRemovedException();
      return CaptainModel.fromJson({
        'id': user.id,
        'name': profile?['full_name'],
        'phone': profile?['phone'],
        'rating': driver['rating']?.toString(),
      });
    } on CaptainRemovedException {
      rethrow;
    } catch (_) {
      // Valid session, but we couldn't load the data right now (transient/RLS/
      // offline) — keep the captain signed in with what the session gives us.
      return CaptainModel.fromJson({
        'id': user.id,
        'name': (user.userMetadata?['full_name'] as String?) ?? '',
        'phone': user.phone ?? user.email ?? '',
      });
    }
  }

  /// Builds the captain profile. When [requireDriver] is true (login), a missing
  /// driver record means the captain was removed → throws so the app blocks
  /// them. Registration (verifyOtp) keeps it false, since a brand-new captain
  /// has no driver record yet.
  Future<CaptainModel> _profileFor(String? userId,
      {bool requireDriver = false}) async {
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
    if (requireDriver && driver == null) throw const CaptainRemovedException();
    return CaptainModel.fromJson({
      'id': profile['id'],
      'name': profile['full_name'],
      'phone': profile['phone'],
      'rating': driver?['rating']?.toString(),
    });
  }
}
