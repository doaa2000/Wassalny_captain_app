import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/wallet.dart';
import 'wallet_remote_data_source.dart';

class WalletSupabaseDataSource implements WalletRemoteDataSource {
  const WalletSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<Wallet> fetchWallet() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');

      final List<Map<String, dynamic>> payments = await _service.client
          .from(AppConstants.tablePayments)
          .select('amount, method, status, paid_at, trip_id')
          .eq('driver_id', userId)
          .order('paid_at', ascending: false)
          .limit(20);

      num balance = 0;
      num pending = 0;
      for (final p in payments) {
        final amount = (p['amount'] as num?) ?? 0;
        if (p['status'] == 'paid') {
          balance += amount;
        } else if (p['status'] == 'pending') {
          pending += amount;
        }
      }

      final transactions = payments.take(5).map((p) {
        final String method = (p['method'] as String?) ?? 'cash';
        final DateTime? paidAt = p['paid_at'] != null
            ? DateTime.tryParse(p['paid_at'] as String)
            : null;
        final String ts = paidAt != null ? _formatTimestamp(paidAt) : '';
        final num amount = (p['amount'] as num?) ?? 0;
        final bool isPaid = p['status'] == 'paid';
        final bool isCash = method == 'cash';

        return WalletTransaction(
          title: isCash ? 'Cash trip' : 'Trip payment',
          timestamp: ts,
          amount: isPaid ? '+ EGP ${amount.toStringAsFixed(0)}' : '– EGP ${amount.toStringAsFixed(0)}',
          type: TransactionType.trip,
          isCredit: isPaid,
        );
      }).toList();

      final String pendingStr = pending > 0
          ? 'EGP ${pending.toStringAsFixed(0)} pending'
          : 'No pending amounts';

      return Wallet(
        availableBalance: 'EGP ${balance.toStringAsFixed(balance >= 1000 ? 0 : 2)}',
        pendingNote: pendingStr,
        payoutAccount: const PayoutAccount(
          bankLabel: '—',
          holderName: '—',
          verified: false,
        ),
        transactions: transactions,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> requestWithdrawal() async {
    try {
      final userId = _service.currentUserId;
      if (userId == null) throw const ServerException('No authenticated user');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final time = DateFormat('HH:mm').format(dt);

    if (date == today) return 'Today · $time';
    if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday · $time';
    }
    return DateFormat('MMM d · HH:mm').format(dt);
  }
}
