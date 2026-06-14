import 'package:equatable/equatable.dart';

enum TransactionType { trip, withdrawal }

class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.title,
    required this.timestamp,
    required this.amount,
    required this.type,
    required this.isCredit,
  });

  final String title;
  final String timestamp;
  final String amount;
  final TransactionType type;
  final bool isCredit;

  @override
  List<Object?> get props => [title, timestamp, amount, isCredit];
}

class PayoutAccount extends Equatable {
  const PayoutAccount({required this.bankLabel, required this.holderName, required this.verified});

  final String bankLabel;
  final String holderName;
  final bool verified;

  @override
  List<Object?> get props => [bankLabel, holderName, verified];
}

class Wallet extends Equatable {
  const Wallet({
    required this.availableBalance,
    required this.pendingNote,
    required this.payoutAccount,
    required this.transactions,
  });

  final String availableBalance;
  final String pendingNote;
  final PayoutAccount payoutAccount;
  final List<WalletTransaction> transactions;

  @override
  List<Object?> get props => [availableBalance, pendingNote, payoutAccount, transactions];
}
