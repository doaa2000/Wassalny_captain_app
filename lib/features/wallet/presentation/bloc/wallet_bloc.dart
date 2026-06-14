import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/usecases/get_wallet.dart';
import '../../domain/usecases/request_withdrawal.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({required GetWallet getWallet, required RequestWithdrawal requestWithdrawal})
      : _getWallet = getWallet,
        _requestWithdrawal = requestWithdrawal,
        super(const WalletState()) {
    on<WalletStarted>(_onStarted);
    on<WalletWithdrawRequested>(_onWithdraw);
  }

  final GetWallet _getWallet;
  final RequestWithdrawal _requestWithdrawal;

  Future<void> _onStarted(WalletStarted event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final result = await _getWallet(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: WalletStatus.failure, errorMessage: f.message)),
      (wallet) => emit(state.copyWith(status: WalletStatus.ready, wallet: wallet)),
    );
  }

  Future<void> _onWithdraw(WalletWithdrawRequested event, Emitter<WalletState> emit) async {
    final result = await _requestWithdrawal(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: WalletStatus.failure, errorMessage: f.message)),
      (_) => emit(state.copyWith(status: WalletStatus.withdrawalRequested)),
    );
  }
}
