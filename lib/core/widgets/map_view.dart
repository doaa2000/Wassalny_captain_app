import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'map_style.dart';

/// Visual states the map can be rendered in.
enum MapVariant { idle, route, tracking }

/// A real Google Map (dark-styled to match the Captain app). For [route] and
/// [tracking] it draws a pickup → drop-off polyline with markers. The public
/// API is unchanged (`MapView({variant})`) so the trip screens keep working;
/// real trip coordinates can be passed later via [pickup]/[dropoff].
class MapView extends StatefulWidget {
  const MapView({
    super.key,
    this.variant = MapVariant.idle,
    this.pickup,
    this.dropoff,
  });

  final MapVariant variant;
  final LatLng? pickup;
  final LatLng? dropoff;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Sample Cairo coordinates until live trip geometry is wired in.
  static const LatLng _defaultPickup = LatLng(30.0444, 31.2357);
  static const LatLng _defaultDropoff = LatLng(30.0626, 31.2497);
  static const LatLng _cairoCenter = LatLng(30.0500, 31.2400);

  GoogleMapController? _controller;

  LatLng get _pickup => widget.pickup ?? _defaultPickup;
  LatLng get _dropoff => widget.dropoff ?? _defaultDropoff;
  bool get _showRoute => widget.variant != MapVariant.idle;

  Set<Marker> _markers(BuildContext context) {
    if (!_showRoute) return const {};
    final l = AppLocalizations.of(context);
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: l?.pickup ?? 'Pickup'),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoff,
        infoWindow: InfoWindow(title: l?.dropoff ?? 'Drop-off'),
      ),
    };
  }

  Set<Polyline> _polylines() {
    if (!_showRoute) return const {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_pickup, _dropoff],
        color: AppColors.primary,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  CameraPosition get _initialCamera => _showRoute
      ? CameraPosition(target: _pickup, zoom: 13.5)
      : const CameraPosition(target: _cairoCenter, zoom: 13);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    if (_showRoute) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          _pickup.latitude < _dropoff.latitude ? _pickup.latitude : _dropoff.latitude,
          _pickup.longitude < _dropoff.longitude ? _pickup.longitude : _dropoff.longitude,
        ),
        northeast: LatLng(
          _pickup.latitude > _dropoff.latitude ? _pickup.latitude : _dropoff.latitude,
          _pickup.longitude > _dropoff.longitude ? _pickup.longitude : _dropoff.longitude,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return; // screen may have been left during the delay
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
    }
  }

  @override
  void dispose() {
    // The GoogleMap widget owns the controller; don't dispose it here or a
    // pending async camera call would hit a disposed controller.
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCamera,
      onMapCreated: _onMapCreated,
      style: captainMapStyle,
      markers: _markers(context),
      polylines: _polylines(),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      padding: const EdgeInsets.only(bottom: 180),
    );
  }
}
