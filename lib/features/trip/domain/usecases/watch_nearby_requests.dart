import '../entities/ride_request.dart';
import '../repositories/trip_repository.dart';

/// Streaming use case: emits the live set of available ride requests so the
/// dashboard can react to Realtime broadcast dispatch. Kept separate from the
/// [UseCase] (Future) contract because it returns a [Stream].
class WatchNearbyRequests {
  const WatchNearbyRequests(this._repository);

  final TripRepository _repository;

  Stream<List<RideRequest>> call() => _repository.watchNearbyRequests();
}
