import '../../domain/entities/trip_history_item.dart';

abstract interface class HistoryRemoteDataSource {
  Future<List<TripHistoryItem>> fetchHistory();
}

/// In-memory ride history seeded from the design.
class HistoryLocalDataSource implements HistoryRemoteDataSource {
  @override
  Future<List<TripHistoryItem>> fetchHistory() async => const [
        TripHistoryItem(
          time: 'Today · 18:24',
          earnings: 'EGP 96',
          from: 'Tahrir Square',
          to: 'Cairo Festival City',
          distance: '14.2 km',
          duration: '24 min',
          passengerName: 'Nadia Saleh',
          passengerInitials: 'NS',
          rating: '4.8',
        ),
        TripHistoryItem(
          time: 'Today · 16:10',
          earnings: 'EGP 54',
          from: 'Dokki',
          to: 'Mohandessin',
          distance: '6.1 km',
          duration: '15 min',
          passengerName: 'Hany R.',
          passengerInitials: 'HR',
          rating: '5.0',
        ),
        TripHistoryItem(
          time: 'Today · 13:38',
          earnings: 'EGP 128',
          from: 'Nasr City',
          to: 'New Cairo',
          distance: '17.4 km',
          duration: '29 min',
          passengerName: 'Salma K.',
          passengerInitials: 'SK',
          rating: '4.7',
        ),
        TripHistoryItem(
          time: 'Yesterday · 21:05',
          earnings: 'EGP 74',
          from: 'Maadi, Rd 9',
          to: 'Zamalek',
          distance: '11.0 km',
          duration: '22 min',
          passengerName: 'Omar A.',
          passengerInitials: 'OA',
          rating: '4.9',
        ),
      ];
}
