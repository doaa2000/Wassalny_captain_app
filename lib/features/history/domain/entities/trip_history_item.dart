import 'package:equatable/equatable.dart';

/// A completed trip shown in the captain's ride history.
class TripHistoryItem extends Equatable {
  const TripHistoryItem({
    required this.time,
    required this.earnings,
    required this.from,
    required this.to,
    required this.distance,
    required this.duration,
    required this.passengerName,
    required this.passengerInitials,
    required this.rating,
  });

  final String time;
  final String earnings;
  final String from;
  final String to;
  final String distance;
  final String duration;
  final String passengerName;
  final String passengerInitials;
  final String rating;

  @override
  List<Object?> get props => [time, earnings, from, to];
}
