part of 'history_bloc.dart';

enum HistoryStatus { initial, loading, ready, failure }

class HistoryState extends Equatable {
  const HistoryState({this.status = HistoryStatus.initial, this.items = const [], this.errorMessage});

  final HistoryStatus status;
  final List<TripHistoryItem> items;
  final String? errorMessage;

  HistoryState copyWith({HistoryStatus? status, List<TripHistoryItem>? items, String? errorMessage}) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
