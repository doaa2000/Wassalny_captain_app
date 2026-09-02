import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/account_removed_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/earnings/presentation/bloc/earnings_bloc.dart';
import '../../features/earnings/presentation/pages/earnings_page.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/support/presentation/cubit/support_cubit.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/trip/presentation/pages/trip_flow_page.dart';
import '../../features/vehicle/presentation/cubit/vehicle_cubit.dart';
import '../../features/vehicle/presentation/pages/vehicle_page.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../dependency_injection/injection_container.dart';
import 'app_routes.dart';
import 'main_shell.dart';

/// The single source of truth for navigation. Each route resolves its bloc from
/// the service locator, keeping page widgets free of construction concerns.
abstract final class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SplashCubit>(),
          child: const SplashPage(),
        ),
      ),

      // ---- Auth (AuthBloc is provided globally above the router) ----
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupPage()),
      GoRoute(path: AppRoutes.otp, builder: (_, __) => const OtpPage()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: AppRoutes.accountRemoved, builder: (_, __) => const AccountRemovedPage()),

      // ---- Main tabs (persistent bottom nav) ----
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<DashboardBloc>()..add(const DashboardStarted()),
                  child: const DashboardPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.earnings,
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<EarningsBloc>()..add(const EarningsStarted()),
                  child: const EarningsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<HistoryBloc>()..add(const HistoryStarted()),
                  child: const HistoryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notifications,
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<NotificationsBloc>()..add(const NotificationsStarted()),
                  child: const NotificationsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<ProfileBloc>()..add(const ProfileStarted()),
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // ---- Trip lifecycle (TripBloc is provided globally above the router) ----
      GoRoute(
        path: AppRoutes.incomingRequest,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const TripFlowPage(),
      ),

      // ---- Profile sub-pages (pushed over the shell) ----
      GoRoute(
        path: AppRoutes.wallet,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
          child: const WalletPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.vehicle,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<VehicleCubit>()..load(),
          child: const VehiclePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.support,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<SupportCubit>()..load(),
          child: const SupportPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const ProfileStarted()),
          child: const EditProfilePage(),
        ),
      ),
    ],
  );
}
