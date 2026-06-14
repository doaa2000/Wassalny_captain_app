part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletStarted extends WalletEvent {
  const WalletStarted();
}

class WalletWithdrawRequested extends WalletEvent {
  const WalletWithdrawRequested();
}
