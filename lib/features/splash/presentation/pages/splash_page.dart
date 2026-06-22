import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/widgets/brand_logo.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _bob;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(vsync: this, duration: const Duration(milliseconds: 1750))
      ..repeat(reverse: true);
    context.read<SplashCubit>().bootstrap();
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  void _continue() => context.go(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            context.go(AppRoutes.dashboard);
          } else if (state is SplashRemoved) {
            context.go(AppRoutes.accountRemoved);
          } else if (state is SplashUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.1,
              colors: [Color(0xFF1B3340), AppColors.darkBackground],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 0.96, end: 1.04).animate(
                          CurvedAnimation(parent: _bob, curve: Curves.easeInOut),
                        ),
                        child: const BrandLogo(size: 104, radius: 32),
                      ),
                      const SizedBox(height: 30),
                      Text.rich(
                        TextSpan(
                          text: 'Wassalny ',
                          style: AppTextStyles.display.copyWith(color: AppColors.textPrimaryDark),
                          children: const [
                            TextSpan(text: 'Captain', style: TextStyle(color: AppColors.primary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(AppConstants.appTagline,
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark)),
                      const SizedBox(height: 40),
                      const _LoadingDots(),
                    ],
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 30,
                  child: TextButton(
                    onPressed: _continue,
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Tap to continue',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Container(
          width: 9,
          height: 9,
          margin: EdgeInsets.only(right: i == 2 ? 0 : 7),
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
