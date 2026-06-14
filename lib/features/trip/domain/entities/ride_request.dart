import 'package:equatable/equatable.dart';

/// A ride request offered to the captain. This is the core domain object shared
/// by the dashboard (nearby requests) and the trip lifecycle.
class RideRequest extends Equatable {
  const RideRequest({
    required this.id,
    required this.tier,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.pickupEtaMinutes,
    required this.pickupDistance,
    required this.passengerName,
    required this.passengerInitials,
    required this.passengerRating,
    required this.paymentMethod,
  });

  final String id;

  /// Service tier label, e.g. "Go", "Comfort".
  final String tier;
  final String pickup;
  final String dropoff;

  /// Total trip distance, e.g. "14.2 km".
  final String distance;

  /// Total trip duration, e.g. "24 min".
  final String duration;

  /// Captain fare/earnings, e.g. "EGP 96".
  final String fare;

  final int pickupEtaMinutes;
  final String pickupDistance;

  final String passengerName;
  final String passengerInitials;
  final String passengerRating;

  /// "Cash" or "Wallet".
  final String paymentMethod;

  @override
  List<Object?> get props => [id];
}
