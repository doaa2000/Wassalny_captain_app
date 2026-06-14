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

  RideRequest toEntity() => this;
}
