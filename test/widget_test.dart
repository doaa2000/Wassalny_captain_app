import 'package:flutter_test/flutter_test.dart';
import 'package:wassalny_captain/features/trip/data/models/ride_request_model.dart';

/// Smoke tests for the passenger-contact plumbing: the ride request model must
/// carry the passenger's phone through JSON (de)serialization and through the
/// `trips`-table row mapping so the captain can call / message the passenger.
void main() {
  group('RideRequestModel passenger contact', () {
    test('fromJson/toJson round-trips the passenger phone', () {
      const phone = '+20 100 123 4567';
      final RideRequestModel model = RideRequestModel.fromJson(const {
        'id': 42,
        'passenger_name': 'Nadia Saleh',
        'passenger_phone': phone,
      });

      expect(model.passengerPhone, phone);
      expect(model.toJson()['passenger_phone'], phone);
    });

    test('fromJson falls back to an empty phone when missing', () {
      final RideRequestModel model = RideRequestModel.fromJson(const {'id': 7});
      expect(model.passengerPhone, '');
    });

    test('fromTripRow reads the phone from the embedded passenger', () {
      final RideRequestModel model = RideRequestModel.fromTripRow(const {
        'id': 'trip-1',
        'trip_price': 96,
        'passenger': {'full_name': 'Omar Adel', 'phone': '+201019876543'},
      });

      expect(model.passengerName, 'Omar Adel');
      expect(model.passengerPhone, '+201019876543');
    });

    test('fromTripRow defaults to an empty phone without a passenger', () {
      final RideRequestModel model =
          RideRequestModel.fromTripRow(const {'id': 'trip-2'});
      expect(model.passengerPhone, '');
    });

    test('copyWith preserves the passenger phone', () {
      final RideRequestModel model = RideRequestModel.fromJson(const {
        'id': 42,
        'passenger_phone': '+20 100 123 4567',
      });

      final RideRequestModel retarged = model.copyWith(fare: 'EGP 120', fareAmount: 120);
      expect(retarged.passengerPhone, '+20 100 123 4567');
      expect(retarged.fare, 'EGP 120');
    });
  });
}
