import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trip history', style: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark)),
                        const SizedBox(height: 14),
                        const _SearchBar(),
                        const SizedBox(height: 12),
                        const _FilterChips(),
                      ],
                    ),
                  ),
                ),
                if (state.status == HistoryStatus.loading || state.status == HistoryStatus.initial)
                  const SliverFillRemaining(hasScrollBody: false, child: LoadingView())
                else if (state.items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyView(title: 'No trips yet', message: 'Completed rides will appear here.'),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    sliver: SliverList.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, i) => HistoryCard(item: state.items[i]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 18, color: AppColors.textMutedDark),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search trips',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMutedDark),
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const List<String> labels = ['All', 'Today', 'This week'];
    return Row(
      children: List.generate(labels.length, (i) {
        final bool active = i == 0;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(11),
              border: active ? null : Border.all(color: AppColors.darkBorder),
            ),
            child: Text(
              labels[i],
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.onPrimary : AppColors.textSecondaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
