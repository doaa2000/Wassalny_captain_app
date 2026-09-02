import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/services/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/trip/presentation/bloc/trip_bloc.dart';
import 'l10n/app_localizations.dart';

/// Root widget. Provides the app-global blocs (auth session and the trip
/// lifecycle, both shared across multiple routes) and configures theming and
/// centralized routing.
class WassalnyCaptainApp extends StatefulWidget {
  const WassalnyCaptainApp({super.key});

  @override
  State<WassalnyCaptainApp> createState() => _WassalnyCaptainAppState();
}

class _WassalnyCaptainAppState extends State<WassalnyCaptainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<TripBloc>(create: (_) => sl<TripBloc>()),
      ],
      child: ListenableBuilder(
        listenable: sl<LocaleController>(),
        builder: (context, _) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            routerConfig: AppRouter.router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: sl<LocaleController>().locale,
          );
        },
      ),
    );
  }
}
