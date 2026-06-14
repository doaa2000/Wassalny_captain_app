import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/earnings_report.dart';
import '../../domain/usecases/get_earnings_report.dart';

part 'earnings_event.dart';
part 'earnings_state.dart';

/// Loads earnings reports and reacts to period changes (Day/Week/Month).
class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  EarningsBloc({required GetEarningsReport getReport})
      : _getReport = getReport,
        super(const EarningsState()) {
    on<EarningsStarted>(_onStarted);
    on<EarningsPeriodChanged>(_onPeriodChanged);
  }

  final GetEarningsReport _getReport;

  Future<void> _onStarted(EarningsStarted event, Emitter<EarningsState> emit) =>
      _load(state.period, emit);

  Future<void> _onPeriodChanged(EarningsPeriodChanged event, Emitter<EarningsState> emit) =>
      _load(event.period, emit);

  Future<void> _load(EarningsPeriod period, Emitter<EarningsState> emit) async {
    emit(state.copyWith(status: EarningsStatus.loading, period: period));
    final result = await _getReport(period);
    result.fold(
      (f) => emit(state.copyWith(status: EarningsStatus.failure, errorMessage: f.message)),
      (report) => emit(state.copyWith(status: EarningsStatus.ready, report: report)),
    );
  }
}
