import '../../domain/entities/ride_request.dart';

/// Data-layer representation of a [RideRequest]. Knows how to (de)serialize
/// from the backend payload and map to the pure domain entity. All
/// backend-shape knowledge lives here, isolated from domain/presentation.
class RideRequestModel extends RideRequest {
  const RideRequestModel({
    required super.id,
    required super.tier,
    required super.pickup,
    required super.dropoff,
    required super.distance,
    required super.duration,
    required super.fare,
    required super.pickupEtaMinutes,
    required super.pickupDistance,
    required super.passengerName,
    required super.passengerInitials,
    required super.passengerRating,
    required super.paymentMethod,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      id: json['id'].toString(),
      tier: json['tier'] as String? ?? 'Go',
      pickup: json['pickup'] as String? ?? '',
      dropoff: json['dropoff'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      fare: json['fare'] as String? ?? '',
      pickupEtaMinutes: (json['pickup_eta'] as num?)?.toInt() ?? 0,
      pickupDistance: json['pickup_distance'] as String? ?? '',
      passengerName: json['passenger_name'] as String? ?? '',
      passengerInitials: json['passenger_initials'] as String? ?? '',
      passengerRating: json['passenger_rating']?.toString() ?? '5.0',
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tier': tier,
        'pickup': pickup,
        'dropoff': dropoff,
        'distance': distance,
        'duration': duration,
        'fare': fare,
        'pickup_eta': pickupEtaMinutes,
        'pickup_distance': pickupDistance,
        'passenger_name': passengerName,
        'passenger_initials': passengerInitials,
        'passenger_rating': passengerRating,
        'payment_method': paymentMethod,
      };

  /// Maps a row from the `trips` table (status = requested), optionally with an
  /// embedded passenger profile, into a request the Captain UI can show.
  /// Fields the schema doesn't carry (tier/eta) fall back to sensible defaults.
  factory RideRequestModel.fromTripRow(Map<String, dynamic> json) {
    final Map<String, dynamic>? passenger =
        (json['passenger'] is Map) ? (json['passenger'] as Map).cast<String, dynamic>() : null;
    final String name = (passenger?['full_name'] as String?)?.trim() ?? 'Passenger';
    final num? price = json['trip_price'] as num?;
    final num? dist = json['estimated_distance'] as num?;
    final num? dur = json['estimated_duration'] as num?;
    final String method = (json['payment_method'] as String?) ?? 'cash';

    return RideRequestModel(
      id: json['id'].toString(),
      tier: json['vehicle_type'] as String? ?? 'Go',
      pickup: json['pickup_address'] as String? ?? '',
      dropoff: json['destination_address'] as String? ?? '',
      distance: dist != null ? '$dist km' : '',
      duration: dur != null ? '$dur min' : '',
      fare: price != null ? 'EGP ${price.toStringAsFixed(0)}' : 'EGP —',
      pickupEtaMinutes: (json['pickup_eta'] as num?)?.toInt() ?? 0,
      pickupDistance: json['pickup_distance'] as String? ?? '',
      passengerName: name,
      passengerInitials: _initialsOf(name),
      passengerRating: json['passenger_rating']?.toString() ?? '5.0',
      paymentMethod: method.isEmpty ? 'Cash' : '${method[0].toUpperCase()}${method.substring(1)}',
    );
  }

  static String _initialsOf(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'P';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  RideRequest toEntity() => this;
}
