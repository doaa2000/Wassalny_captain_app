part of 'earnings_bloc.dart';

enum EarningsStatus { initial, loading, ready, failure }

class EarningsState extends Equatable {
  const EarningsState({
    this.status = EarningsStatus.initial,
    this.period = EarningsPeriod.week,
    this.report,
    this.errorMessage,
  });

  final EarningsStatus status;
  final EarningsPeriod period;
  final EarningsReport? report;
  final String? errorMessage;

  EarningsState copyWith({
    EarningsStatus? status,
    EarningsPeriod? period,
    EarningsReport? report,
    String? errorMessage,
  }) {
    return EarningsState(
      status: status ?? this.status,
      period: period ?? this.period,
      report: report ?? this.report,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, period, report, errorMessage];
}
