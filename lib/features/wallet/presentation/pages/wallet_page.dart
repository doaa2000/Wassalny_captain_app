import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/wallet.dart';
import '../bloc/wallet_bloc.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<WalletBloc, WalletState>(
          listenWhen: (p, c) => c.status == WalletStatus.withdrawalRequested,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Withdrawal requested.')));
          },
          builder: (context, state) {
            final wallet = state.wallet;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                PageHeader(title: 'Wallet', showBack: true, onBack: () => context.pop()),
                const SizedBox(height: 16),
                if (wallet == null)
                  const Padding(padding: EdgeInsets.only(top: 80), child: LoadingView())
                else ...[
                  _BalanceCard(
                    wallet: wallet,
                    onWithdraw: () => context.read<WalletBloc>().add(const WalletWithdrawRequested()),
                  ),
                  const SizedBox(height: 22),
                  Text('Payout account', style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 12),
                  _PayoutCard(account: wallet.payoutAccount),
                  const SizedBox(height: 22),
                  Text('Transactions', style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        for (int i = 0; i < wallet.transactions.length; i++) ...[
                          _TransactionRow(transaction: wallet.transactions[i]),
                          if (i != wallet.transactions.length - 1)
                            const Divider(height: 1, color: AppColors.darkDivider),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.wallet, required this.onWithdraw});

  final Wallet wallet;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 40, offset: const Offset(0, 18))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available balance', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 6),
          Text(wallet.availableBalance, style: AppTextStyles.amountLarge.copyWith(color: AppColors.white, fontSize: 36)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 15, color: Colors.white.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(wallet.pendingNote,
                    style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: onWithdraw,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primaryDeep,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.download_rounded, size: 19),
              label: Text('Withdraw earnings', style: AppTextStyles.buttonSmall.copyWith(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  const _PayoutCard({required this.account});

  final PayoutAccount account;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.bankLabel, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                Text(account.holderName, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
              ],
            ),
          ),
          if (account.verified) const StatusBadge(label: 'Verified', color: AppColors.success),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final bool credit = transaction.isCredit;
    final IconData icon = transaction.type == TransactionType.trip
        ? Icons.local_taxi_rounded
        : Icons.upload_rounded;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: credit ? AppColors.success.withValues(alpha: 0.14) : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: credit ? AppColors.success : AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                Text(transaction.timestamp, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: AppTextStyles.bodyStrong.copyWith(
              color: credit ? AppColors.success : AppColors.textPrimaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
