import '../../domain/entities/captain.dart';

class CaptainModel extends Captain {
  const CaptainModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.initials,
    super.rating,
    super.memberSince,
    super.approvalStatus,
    super.rejectionReason,
  });

  factory CaptainModel.fromJson(Map<String, dynamic> json) {
    final String name = json['name'] as String? ?? '';
    return CaptainModel(
      id: json['id'].toString(),
      name: name,
      phone: json['phone'] as String? ?? '',
      initials: json['initials'] as String? ?? _initialsOf(name),
      rating: json['rating']?.toString() ?? '0.0',
      memberSince: json['member_since'] as String?,
      approvalStatus: json['approval_status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'initials': initials,
        'rating': rating,
        'member_since': memberSince,
        'approval_status': approvalStatus,
        'rejection_reason': rejectionReason,
      };

  static String _initialsOf(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
