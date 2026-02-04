import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'providers/auth_provider.dart';
import 'services/local_storage.dart';
import 'utils/theme.dart';
import 'utils/router.dart';
import 'widgets/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  final localStorage = LocalStorage();
  await localStorage.init();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(localStorage),
      ],
      child: const KpiProbationApp(),
    ),
  );
}

class KpiProbationApp extends ConsumerStatefulWidget {
  const KpiProbationApp({super.key});

  @override
  ConsumerState<KpiProbationApp> createState() => _KpiProbationAppState();
}

class _KpiProbationAppState extends ConsumerState<KpiProbationApp> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state
    Future.microtask(() {
      ref.read(authProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final authState = ref.watch(authProvider);

    // Show loading while initializing
    if (authState.status == AuthStatus.initial) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoadingScreen(message: 'กำลังโหลด...'),
      );
    }

    return MaterialApp.router(
      title: 'KPI Probation Tracking',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      locale: const Locale('th', 'TH'),

      // Router
      routerConfig: router,
    );
  }
}
