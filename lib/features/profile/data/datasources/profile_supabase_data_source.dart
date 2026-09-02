import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/captain_profile.dart';
import 'profile_remote_data_source.dart';

class ProfileSupabaseDataSource implements ProfileRemoteDataSource {
  const ProfileSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<CaptainProfile> fetchProfile() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final Map<String, dynamic> profile = await _service.client
          .from(AppConstants.tableProfiles)
          .select('full_name, created_at')
          .eq('id', userId)
          .single();

      final Map<String, dynamic>? driver = await _service.client
          .from(AppConstants.tableDrivers)
          .select('rating, total_trips')
          .eq('profile_id', userId)
          .maybeSingle();

      final String name = (profile['full_name'] as String?) ?? 'Captain';
      final String initials = _initials(name);
      final DateTime? createdAt = profile['created_at'] != null
          ? DateTime.tryParse(profile['created_at'] as String)
          : null;
      final String memberSince = createdAt != null
          ? 'Captain since ${createdAt.year}'
          : 'Captain';
      final num rating = (driver?['rating'] as num?) ?? 0;
      final int totalTrips = (driver?['total_trips'] as int?) ?? 0;

      return CaptainProfile(
        name: name,
        initials: initials,
        memberSince: memberSince,
        rating: rating.toStringAsFixed(2),
        ratingLabel: '${rating.toStringAsFixed(2)} · Top rated',
        totalTrips: _formatNumber(totalTrips),
        acceptanceRate: '—',
        completionRate: '—',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CaptainProfile> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      await _service.client
          .from(AppConstants.tableProfiles)
          .update({'full_name': name, 'phone': phone})
          .eq('id', userId);

      // Re-fetch the updated profile so the UI reflects the latest data.
      return fetchProfile();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return NumberFormat('#,##0').format(n);
    }
    return n.toString();
  }
}
