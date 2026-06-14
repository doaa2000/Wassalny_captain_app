import 'package:equatable/equatable.dart';

/// The authenticated captain (driver) account.
class Captain extends Equatable {
  const Captain({
    required this.id,
    required this.name,
    required this.phone,
    required this.initials,
    this.rating = '0.0',
    this.memberSince,
  });

  final String id;
  final String name;
  final String phone;
  final String initials;
  final String rating;
  final String? memberSince;

  @override
  List<Object?> get props => [id, name, phone];
}
