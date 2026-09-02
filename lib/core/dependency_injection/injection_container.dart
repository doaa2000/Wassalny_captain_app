import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_supabase_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_captain.dart';
import '../../features/auth/domain/usecases/register_captain.dart';
import '../../features/auth/domain/usecases/request_password_reset.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/datasources/dashboard_supabase_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/domain/usecases/set_online_status.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/earnings/data/datasources/earnings_remote_data_source.dart';
import '../../features/earnings/data/datasources/earnings_supabase_data_source.dart';
import '../../features/earnings/data/repositories/earnings_repository_impl.dart';
import '../../features/earnings/domain/repositories/earnings_repository.dart';
import '../../features/earnings/domain/usecases/get_earnings_report.dart';
import '../../features/earnings/presentation/bloc/earnings_bloc.dart';
import '../../features/history/data/datasources/history_remote_data_source.dart';
import '../../features/history/data/datasources/history_supabase_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_trip_history.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/datasources/notifications_supabase_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_supabase_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/support/data/datasources/support_remote_data_source.dart';
import '../../features/support/data/datasources/support_supabase_data_source.dart';
import '../../features/support/data/repositories/support_repository_impl.dart';
import '../../features/support/domain/repositories/support_repository.dart';
import '../../features/support/domain/usecases/get_support_content.dart';
import '../../features/support/presentation/cubit/support_cubit.dart';
import '../../features/trip/data/datasources/trip_local_data_source.dart';
import '../../features/trip/data/datasources/trip_remote_data_source.dart';
import '../../features/trip/data/datasources/trip_supabase_data_source.dart';
import '../../features/trip/data/repositories/trip_repository_impl.dart';
import '../../features/trip/data/services/communication_service.dart';
import '../../features/trip/domain/repositories/trip_repository.dart';
import '../../features/trip/domain/usecases/accept_request.dart';
import '../../features/trip/domain/usecases/complete_trip.dart';
import '../../features/trip/domain/usecases/get_nearby_requests.dart';
import '../../features/trip/domain/usecases/watch_nearby_requests.dart';
import '../../features/trip/presentation/bloc/trip_bloc.dart';
import '../../features/vehicle/data/datasources/vehicle_remote_data_source.dart';
import '../../features/vehicle/data/datasources/vehicle_supabase_data_source.dart';
import '../../features/vehicle/data/repositories/vehicle_repository_impl.dart';
import '../../features/vehicle/domain/repositories/vehicle_repository.dart';
import '../../features/vehicle/domain/usecases/get_vehicle.dart';
import '../../features/vehicle/presentation/cubit/vehicle_cubit.dart';
import '../../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../../features/wallet/data/datasources/wallet_supabase_data_source.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/get_wallet.dart';
import '../../features/wallet/domain/usecases/request_withdrawal.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../constants/app_constants.dart';
import '../services/locale_controller.dart';
import '../services/location_sharing_service.dart';
import '../services/supabase_service.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Wires up the entire object graph: services → data sources → repositories →
/// use cases → blocs. Call once during bootstrap (after Flutter is
/// initialized) before running the app.
Future<void> configureDependencies() async {
  // ---- Core services ----
  final SupabaseService supabaseService = SupabaseServiceImpl();
  await supabaseService.initialize();
  sl.registerSingleton<SupabaseService>(supabaseService);

  // Locale controller drives the app language (persisted).
  final LocaleController localeController = LocaleController();
  await localeController.load();
  sl.registerSingleton<LocaleController>(localeController);

  // Use the live backend only when credentials are configured; otherwise fall
  // back to in-memory data sources so the app is fully runnable for UI work.
  final bool useRemote = AppConstants.supabaseUrl.isNotEmpty &&
      AppConstants.supabaseAnonKey.isNotEmpty;

  // Loud startup banner so it's obvious whether the app is talking to Supabase.
  debugPrint('======================================================');
  if (useRemote) {
    debugPrint('🟢 WASSALNY: LIVE mode — connected to Supabase');
    debugPrint('   URL = ${AppConstants.supabaseUrl}');
  } else {
    debugPrint('🟡 WASSALNY: MOCK mode — NOT connected to Supabase.');
    debugPrint('   Run with: flutter run \\');
    debugPrint('     --dart-define=SUPABASE_URL=https://<ref>.supabase.co \\');
    debugPrint('     --dart-define=SUPABASE_ANON_KEY=<anon-key>');
  }
  debugPrint('======================================================');

  _registerAuth(useRemote);
  _registerTrip(useRemote);
  _registerDashboard(useRemote);
  _registerEarnings(useRemote);
  _registerWallet(useRemote);
  _registerHistory(useRemote);
  _registerNotifications(useRemote);
  _registerProfile(useRemote);
  _registerVehicle(useRemote);
  _registerSupport(useRemote);
  _registerSplash();
}

void _registerAuth(bool useRemote) {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => useRemote ? AuthSupabaseDataSource(sl()) : AuthLocalDataSource(),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginCaptain(sl()));
  sl.registerLazySingleton(() => RegisterCaptain(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl()));
  // Auth state is global, so the bloc is a singleton shared across pages.
  sl.registerLazySingleton(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      verifyOtp: sl(),
      requestPasswordReset: sl(),
      repository: sl(),
    ),
  );
}

void _registerTrip(bool useRemote) {
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => useRemote ? TripSupabaseDataSource(sl()) : TripLocalDataSource(),
  );
  sl.registerLazySingleton<CommunicationService>(() => const CommunicationService());
  sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetNearbyRequests(sl()));
  sl.registerLazySingleton(() => WatchNearbyRequests(sl()));
  sl.registerLazySingleton(() => AcceptRequest(sl()));
  sl.registerLazySingleton(() => CompleteTrip(sl()));
  sl.registerLazySingleton(() => LocationSharingService(sl<SupabaseService>()));
  // Shared across the trip flow and dashboard, so it's a singleton.
  sl.registerLazySingleton(
    () => TripBloc(
      acceptRequest: sl(),
      completeTrip: sl(),
      repository: sl(),
      locationSharing: sl<LocationSharingService>(),
    ),
  );
}

void _registerDashboard(bool useRemote) {
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => useRemote ? DashboardSupabaseDataSource(sl()) : DashboardLocalDataSource(),
  );
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetDashboardSummary(sl()));
  sl.registerLazySingleton(() => SetOnlineStatus(sl()));
  sl.registerFactory(
    () => DashboardBloc(
      getSummary: sl(),
      setOnline: sl(),
      getNearbyRequests: sl(),
      watchNearbyRequests: sl(),
    ),
  );
}

void _registerEarnings(bool useRemote) {
  sl.registerLazySingleton<EarningsRemoteDataSource>(
    () => useRemote ? EarningsSupabaseDataSource(sl()) : EarningsLocalDataSource(),
  );
  sl.registerLazySingleton<EarningsRepository>(() => EarningsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetEarningsReport(sl()));
  sl.registerFactory(() => EarningsBloc(getReport: sl()));
}

void _registerWallet(bool useRemote) {
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => useRemote ? WalletSupabaseDataSource(sl()) : WalletLocalDataSource(),
  );
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetWallet(sl()));
  sl.registerLazySingleton(() => RequestWithdrawal(sl()));
  sl.registerFactory(() => WalletBloc(getWallet: sl(), requestWithdrawal: sl()));
}

void _registerHistory(bool useRemote) {
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => useRemote ? HistorySupabaseDataSource(sl()) : HistoryLocalDataSource(),
  );
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetTripHistory(sl()));
  sl.registerFactory(() => HistoryBloc(getHistory: sl()));
}

void _registerNotifications(bool useRemote) {
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => useRemote ? NotificationsSupabaseDataSource(sl()) : NotificationsLocalDataSource(),
  );
  sl.registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerFactory(() => NotificationsBloc(getNotifications: sl(), repository: sl()));
}

void _registerProfile(bool useRemote) {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => useRemote ? ProfileSupabaseDataSource(sl()) : ProfileLocalDataSource(),
  );
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), updateProfile: sl()));
}

void _registerVehicle(bool useRemote) {
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => useRemote ? VehicleSupabaseDataSource(sl()) : VehicleLocalDataSource(),
  );
  sl.registerLazySingleton<VehicleRepository>(() => VehicleRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetVehicle(sl()));
  sl.registerFactory(() => VehicleCubit(sl()));
}

void _registerSupport(bool useRemote) {
  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => useRemote ? SupportSupabaseDataSource(sl()) : SupportLocalDataSource(),
  );
  sl.registerLazySingleton<SupportRepository>(() => SupportRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSupportContent(sl()));
  sl.registerFactory(() => SupportCubit(sl()));
}

void _registerSplash() {
  sl.registerFactory(() => SplashCubit(sl()));
}
