import 'package:cronometraje_app/services/chrono_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';
import 'package:cronometraje_app/views/home_view.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ChronokeeperApp());
}

/// Configuración de controlador para alerta de actualización.
final upgrader = Upgrader(
  debugLogging: true, // Comentar en release
  durationUntilAlertAgain: const Duration(minutes: 10),
  countryCode: 'CL'
);

/// Configuración de navegación.
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => UpgradeAlert(
        upgrader: upgrader,
        child: const HomeView()
      ),
    ),
    /**GoRoute(
      path: '/myChronos',
      builder: (context, state) => const MyChronosView(),
    ),
    GoRoute(
      path: '/createChrono',
      builder: (context, state) => const CreateChronoView(),
    ),
    GoRoute(
      path: '/chrono/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return SingleChronoView(chronoId: id);
      },
    ),
    GoRoute(
      path: '/myRecords',
      builder: (context, state) => const MyRecordsView(),
    ),
    GoRoute(
      path: '/chrono/:id/records',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return SingleChronoRecordsView(chronoId: id);
      }
    ),*/
  ],
);

final ThemeData chronoTheme = ThemeData(
  primaryColor: Color(0xFF007AFF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF007AFF),
    primary: Color(0xFF007AFF),
    secondary: Color(0xFFFF9500),
  ),
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF333333)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF007AFF),
    foregroundColor: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFFF9500),
    textTheme: ButtonTextTheme.primary,
  ),
);

/// Widget raiz.
class ChronokeeperApp extends StatelessWidget {
  const ChronokeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChronoViewModel(ChronoService())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Chronokeeper',
        theme: chronoTheme,
        routerConfig: _router,
        locale: const Locale('es', 'CL'), // Configuración para español (Chile)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // Agrega CupertinoLocalizations
        ],
        supportedLocales: const [
          Locale('es', 'CL'), // Español (Chile)
        ],
      ),
    );
  }
}
