part of 'earnings_bloc.dart';

sealed class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object?> get props => [];
}

class EarningsStarted extends EarningsEvent {
  const EarningsStarted();
}

class EarningsPeriodChanged extends EarningsEvent {
  const EarningsPeriodChanged(this.period);
  final EarningsPeriod period;

  @override
  List<Object?> get props => [period];
}
