import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/trip_history_item.dart';
import '../../domain/usecases/get_trip_history.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({required GetTripHistory getHistory})
      : _getHistory = getHistory,
        super(const HistoryState()) {
    on<HistoryStarted>(_onStarted);
  }

  final GetTripHistory _getHistory;

  Future<void> _onStarted(HistoryStarted event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    final result = await _getHistory(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: HistoryStatus.failure, errorMessage: f.message)),
      (items) => emit(state.copyWith(status: HistoryStatus.ready, items: items)),
    );
  }
}
