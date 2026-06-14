import '../../domain/entities/wallet.dart';

abstract interface class WalletRemoteDataSource {
  Future<Wallet> fetchWallet();
  Future<void> requestWithdrawal();
}

/// In-memory wallet seeded from the design.
class WalletLocalDataSource implements WalletRemoteDataSource {
  @override
  Future<Wallet> fetchWallet() async => const Wallet(
        availableBalance: 'EGP 3,820.00',
        pendingNote: 'EGP 642 pending · clears in 2 days',
        payoutAccount: PayoutAccount(
          bankLabel: 'CIB Bank ·· 4821',
          holderName: 'Tarek Mahmoud',
          verified: true,
        ),
        transactions: [
          WalletTransaction(
            title: 'Trip · Tahrir → CFC',
            timestamp: 'Today · 18:24',
            amount: '+ EGP 96',
            type: TransactionType.trip,
            isCredit: true,
          ),
          WalletTransaction(
            title: 'Withdrawal to CIB',
            timestamp: 'Yesterday · 20:02',
            amount: '– EGP 2,400',
            type: TransactionType.withdrawal,
            isCredit: false,
          ),
          WalletTransaction(
            title: 'Trip · Maadi → Zamalek',
            timestamp: 'Yesterday · 14:02',
            amount: '+ EGP 74',
            type: TransactionType.trip,
            isCredit: true,
          ),
        ],
      );

  @override
  Future<void> requestWithdrawal() async {}
}
