import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';

/// Thin wrapper around the Supabase client.
///
/// This is the ONLY place in the app aware of how the backend client is
/// constructed. Remote data sources depend on this service (an injected
/// abstraction), never on the global `Supabase.instance` singleton directly,
/// which keeps the data layer testable and the backend swappable.
abstract interface class SupabaseService {
  /// Initializes the backend client. Call once during bootstrap.
  Future<void> initialize();

  /// The underlying client used by remote data sources.
  SupabaseClient get client;

  /// Currently authenticated user id, or `null` when signed out.
  String? get currentUserId;
}

class SupabaseServiceImpl implements SupabaseService {
  SupabaseClient? _client;

  @override
  Future<void> initialize() async {
    // When no credentials are supplied (e.g. local UI development) we skip the
    // network init so the app still boots against the in-memory fake sources.
    if (AppConstants.supabaseUrl.isEmpty || AppConstants.supabaseAnonKey.isEmpty) {
      return;
    }
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  @override
  SupabaseClient get client {
    final client = _client;
    if (client == null) {
      throw StateError(
        'SupabaseService used before initialization or without credentials.',
      );
    }
    return client;
  }

  @override
  String? get currentUserId => _client?.auth.currentUser?.id;
}
