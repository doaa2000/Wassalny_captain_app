import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';
import 'supabase_service.dart';

/// Streams the captain's GPS to Supabase while a trip is active so the rider can
/// track the car in real time. Writes to `driver_locations` (read live by the
/// rider via Realtime) and keeps `drivers.current_location` fresh for dispatch.
///
/// Foreground only for now (the captain keeps the app open during a trip).
class LocationSharingService {
  LocationSharingService(this._service);

  final SupabaseService _service;

  StreamSubscription<Position>? _sub;
  String? _tripId;

  bool get isSharing => _sub != null;

  /// Begins sharing location for [tripId]. No-op when there's no backend
  /// session (mock mode) or location permission is denied.
  Future<void> start(String tripId) async {
    await stop();
    if (_service.currentUserId == null) return; // mock mode / signed out
    _tripId = tripId;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return;
    }

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // emit every ~15 metres
      ),
    ).listen(_push, onError: (_) {});
  }

  Future<void> _push(Position pos) async {
    final String? uid = _service.currentUserId;
    if (uid == null) return;
    try {
      await _service.client.from(AppConstants.tableDriverLocations).insert({
        'driver_id': uid,
        'trip_id': _tripId,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'heading': pos.heading,
        'speed': pos.speed,
        'accuracy': pos.accuracy,
      });
      await _service.client.from(AppConstants.tableDrivers).update({
        'current_latitude': pos.latitude,
        'current_longitude': pos.longitude,
      }).eq('profile_id', uid);
    } catch (_) {
      // Network blip — the next fix will catch up.
    }
  }

  /// Stops sharing (trip ended / declined / reset).
  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _tripId = null;
  }
}
