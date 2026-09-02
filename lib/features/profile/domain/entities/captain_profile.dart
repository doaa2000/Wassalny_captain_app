import 'package:equatable/equatable.dart';

/// Aggregated profile view-model: identity plus performance stats.
class CaptainProfile extends Equatable {
  const CaptainProfile({
    required this.name,
    required this.initials,
    required this.memberSince,
    required this.rating,
    required this.ratingLabel,
    required this.totalTrips,
    required this.acceptanceRate,
    required this.completionRate,
    this.phone = '',
  });

  final String name;
  final String initials;
  final String memberSince;
  final String rating;
  final String ratingLabel;
  final String totalTrips;
  final String acceptanceRate;
  final String completionRate;
  final String phone;

  @override
  List<Object?> get props =>
      [name, initials, memberSince, rating, totalTrips, acceptanceRate, completionRate, phone];
}
