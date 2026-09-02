import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/vehicle.dart';
import 'vehicle_remote_data_source.dart';

class VehicleSupabaseDataSource implements VehicleRemoteDataSource {
  const VehicleSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<Vehicle> fetchVehicle() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final Map<String, dynamic> driver = await _service.client
          .from(AppConstants.tableDrivers)
          .select(
            'vehicle_model, vehicle_color, vehicle_year, plate_number, '
            'vehicle_type, approval_status',
          )
          .eq('profile_id', userId)
          .single();

      final String model = (driver['vehicle_model'] as String?) ?? 'Unknown';
      final String color = (driver['vehicle_color'] as String?) ?? '';
      final int? year = driver['vehicle_year'] as int?;
      final String plate = (driver['plate_number'] as String?) ?? '';
      final String tier = _tierLabel((driver['vehicle_type'] as String?) ?? 'economy');
      final String specs = [
        if (year != null) '$year',
        if (color.isNotEmpty) color,
      ].join(' · ');

      final List<Map<String, dynamic>> docs = await _service.client
          .from(AppConstants.tableDriverDocuments)
          .select('document_type, verification_status, expires_at')
          .eq('driver_id', userId)
          .order('created_at');

      final vehicleDocs = docs.map((d) {
        final String type = (d['document_type'] as String?) ?? '';
        final String status = (d['verification_status'] as String?) ?? 'pending';
        final DateTime? expiresAt = d['expires_at'] != null
            ? DateTime.tryParse(d['expires_at'] as String)
            : null;

        return VehicleDocument(
          title: _docTitle(type),
          detail: _docDetail(status, expiresAt),
          status: _docStatus(status),
        );
      }).toList();

      return Vehicle(
        model: model,
        specs: specs.isNotEmpty ? specs : '—',
        plate: plate,
        serviceTier: tier,
        documents: vehicleDocs,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _tierLabel(String type) => switch (type) {
        'economy' => 'Go · Economy',
        'comfort' => 'Go · Comfort',
        'suv' => 'SUV · Premium',
        'van' => 'Van · XL',
        'motorbike' => 'Bike · Flash',
        _ => type,
      };

  String _docTitle(String type) => switch (type) {
        'vehicle_registration' => 'Vehicle registration',
        'vehicle_insurance' => 'Insurance',
        'driver_license' => 'Driver license',
        'national_id' => 'National ID',
        'vehicle_photo' => 'Vehicle photo',
        'profile_photo' => 'Profile photo',
        _ => type,
      };

  DocumentStatus _docStatus(String status) => switch (status) {
        'verified' => DocumentStatus.valid,
        'pending' => DocumentStatus.renewSoon,
        'rejected' => DocumentStatus.renewSoon,
        _ => DocumentStatus.valid,
      };

  String _docDetail(String status, DateTime? expiresAt) {
    if (expiresAt != null) {
      final now = DateTime.now();
      final daysLeft = expiresAt.difference(now).inDays;
      if (daysLeft < 0) return 'Expired ${DateFormat('MMM yyyy').format(expiresAt)}';
      if (daysLeft < 30) return 'Expires in $daysLeft days';
      return 'Valid until ${DateFormat('MMM yyyy').format(expiresAt)}';
    }
    return switch (status) {
      'verified' => 'Verified',
      'pending' => 'Pending review',
      'rejected' => 'Needs renewal',
      _ => '—',
    };
  }
}
