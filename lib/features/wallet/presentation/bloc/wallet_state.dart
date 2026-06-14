part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, ready, withdrawalRequested, failure }

class WalletState extends Equatable {
  const WalletState({this.status = WalletStatus.initial, this.wallet, this.errorMessage});

  final WalletStatus status;
  final Wallet? wallet;
  final String? errorMessage;

  WalletState copyWith({WalletStatus? status, Wallet? wallet, String? errorMessage}) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallet, errorMessage];
}
