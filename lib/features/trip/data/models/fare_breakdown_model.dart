import '../../domain/entities/fare_breakdown.dart';

class FareBreakdownModel extends FareBreakdown {
  const FareBreakdownModel({
    required super.tripFare,
    required super.serviceFee,
    required super.peakBonus,
    required super.total,
    required super.distance,
    required super.duration,
    required super.paymentMethod,
  });

  factory FareBreakdownModel.fromJson(Map<String, dynamic> json) {
    return FareBreakdownModel(
      tripFare: json['trip_fare'] as String? ?? '',
      serviceFee: json['service_fee'] as String? ?? '',
      peakBonus: json['peak_bonus'] as String? ?? '',
      total: json['total'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
    );
  }
}
