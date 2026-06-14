import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/support_content.dart';
import '../cubit/support_cubit.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SupportCubit, SupportState>(
          builder: (context, state) {
            final content = state.content;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                PageHeader(title: 'Support center', showBack: true, onBack: () => context.pop(), fontSize: 22),
                const SizedBox(height: 14),
                if (content == null)
                  const Padding(padding: EdgeInsets.only(top: 80), child: LoadingView())
                else ...[
                  _LiveChatCard(replyTime: content.chatReplyTime),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ContactCard(
                          icon: Icons.call_rounded,
                          iconColor: AppColors.primary,
                          title: 'Call hotline',
                          subtitle: content.hotline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _ContactCard(
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.danger,
                          title: 'Report incident',
                          subtitle: 'Safety & accidents',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text('Frequently asked',
                      style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 10),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (int i = 0; i < content.faqs.length; i++) ...[
                          _FaqRow(faq: content.faqs[i]),
                          if (i != content.faqs.length - 1)
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

class _LiveChatCard extends StatelessWidget {
  const _LiveChatCard({required this.replyTime});

  final String replyTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 34, offset: const Offset(0, 16))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Live chat support', style: AppTextStyles.cardTitle.copyWith(color: AppColors.white)),
                Text(replyTime, style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
          const _OnlineDot(),
        ],
      ),
    );
  }
}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark)),
          Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark)),
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.faq});

  final FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(faq.question, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimaryDark)),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMutedDark, size: 22),
        ],
      ),
    );
  }
}
