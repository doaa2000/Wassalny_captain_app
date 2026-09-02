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
    this.approvalStatus = 'pending',
    this.rejectionReason,
  });

  final String id;
  final String name;
  final String phone;
  final String initials;
  final String rating;
  final String? memberSince;

  /// One of 'pending' | 'approved' | 'rejected' | 'suspended' (server enum
  /// `public.approval_status`) — gates whether the captain can reach the
  /// dashboard or sees a pending/rejected screen instead.
  final String approvalStatus;
  final String? rejectionReason;

  @override
  List<Object?> get props => [id, name, phone, approvalStatus];
}
