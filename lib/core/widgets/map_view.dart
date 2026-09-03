import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'map_center_pin.dart';
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
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  // Sample Cairo coordinates until live trip geometry is wired in.
  static const LatLng _defaultPickup = LatLng(30.0444, 31.2357);
  static const LatLng _defaultDropoff = LatLng(30.0626, 31.2497);
  static const LatLng _cairoCenter = LatLng(30.0500, 31.2400);
  static const double _sheetPadding = 180;

  GoogleMapController? _controller;

  /// The captain's (driver's) live position, resolved once and on map create.
  LatLng? _driverLocation;
  bool _locationRequested = false;
  bool _pinLifted = false;
  bool _recentering = false;

  LatLng get _pickup => widget.pickup ?? _defaultPickup;
  LatLng get _dropoff => widget.dropoff ?? _defaultDropoff;
  bool get _showRoute => widget.variant != MapVariant.idle;

  Set<Marker> _markers(BuildContext context) {
    final l = AppLocalizations.of(context);
    final Set<Marker> markers = {};

    // On the idle dashboard the center overlay pin is the location marker.
    // On trip maps, keep a driver marker at the live GPS coordinate.
    if (_showRoute && _driverLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: _driverLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: l?.driverLocation ?? 'You'),
      ));
    }

    if (!_showRoute) return markers;
    markers.addAll([
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
    ]);
    return markers;
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

  Future<LatLng?> _readCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 12));
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  /// Resolves the captain's current position (once) via [Geolocator], marks it
  /// on the map, and — on the dashboard (idle) — re-centers the camera on them.
  Future<void> _locateDriver() async {
    if (_locationRequested) return;
    _locationRequested = true;
    final LatLng? driverPosition = await _readCurrentPosition();
    if (!mounted || driverPosition == null) return;
    setState(() => _driverLocation = driverPosition);
    if (widget.variant == MapVariant.idle) {
      await _controller?.animateCamera(CameraUpdate.newLatLngZoom(driverPosition, 15));
    }
  }

  Future<void> goToMyLocation() async {
    if (_recentering) return;
    setState(() => _recentering = true);
    try {
      final LatLng? position = await _readCurrentPosition() ?? _driverLocation;
      if (!mounted || position == null) return;
      setState(() => _driverLocation = position);
      await _controller?.animateCamera(CameraUpdate.newLatLngZoom(position, 16));
    } finally {
      if (mounted) setState(() => _recentering = false);
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    _locateDriver();
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
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialCamera,
          onMapCreated: _onMapCreated,
          onCameraMove: (_) {
            if (!_pinLifted && !_showRoute) setState(() => _pinLifted = true);
          },
          onCameraIdle: () {
            if (_pinLifted) setState(() => _pinLifted = false);
          },
          style: captainMapStyle,
          markers: _markers(context),
          polylines: _polylines(),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          padding: const EdgeInsets.only(bottom: _sheetPadding),
        ),
        if (!_showRoute)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: _sheetPadding,
            child: IgnorePointer(
              child: Center(child: MapCenterPin(lifted: _pinLifted)),
            ),
          ),
      ],
    );
  }
}

/// Recenter FAB. Place it in the parent stack *above* the bottom sheet so it
/// is not covered — the map itself sits underneath those overlays.
class MapMyLocationButton extends StatelessWidget {
  const MapMyLocationButton({
    super.key,
    required this.onPressed,
    this.busy = false,
  });

  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final String tooltip = AppLocalizations.of(context)?.myLocation ?? 'My location';
    return Material(
      color: AppColors.white,
      elevation: 8,
      shadowColor: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: busy ? null : onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hosts a [MapView] and supplies a [MapMyLocationButton] that talks to it.
/// Parents must put [myLocationButton] *above* bottom sheets in the z-order.
class MapScaffold extends StatefulWidget {
  const MapScaffold({
    super.key,
    this.variant = MapVariant.idle,
    this.pickup,
    this.dropoff,
    required this.builder,
  });

  final MapVariant variant;
  final LatLng? pickup;
  final LatLng? dropoff;
  final Widget Function(BuildContext context, Widget map, Widget myLocationButton) builder;

  @override
  State<MapScaffold> createState() => _MapScaffoldState();
}

class _MapScaffoldState extends State<MapScaffold> {
  final GlobalKey<MapViewState> _mapKey = GlobalKey<MapViewState>();

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      MapView(
        key: _mapKey,
        variant: widget.variant,
        pickup: widget.pickup,
        dropoff: widget.dropoff,
      ),
      MapMyLocationButton(onPressed: () => _mapKey.currentState?.goToMyLocation()),
    );
  }
}

/// Places the my-location FAB just above a bottom sheet.
class MapSheetStack extends StatelessWidget {
  const MapSheetStack({
    super.key,
    required this.myLocationButton,
    required this.sheet,
  });

  final Widget myLocationButton;
  final Widget sheet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 16, bottom: 10),
            child: myLocationButton,
          ),
        ),
        sheet,
      ],
    );
  }
}
