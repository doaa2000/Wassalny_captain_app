import 'package:equatable/equatable.dart';

/// Settlement details shown on the "Trip completed" screen.
class FareBreakdown extends Equatable {
  const FareBreakdown({
    required this.tripFare,
    required this.serviceFee,
    required this.peakBonus,
    required this.total,
    required this.distance,
    required this.duration,
    required this.paymentMethod,
  });

  final String tripFare;
  final String serviceFee;
  final String peakBonus;
  final String total;
  final String distance;
  final String duration;
  final String paymentMethod;

  @override
  List<Object?> get props => [tripFare, serviceFee, peakBonus, total];
}
