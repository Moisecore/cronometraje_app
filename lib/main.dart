import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'viewmodels/chrono_viewmodel.dart';
import 'views/home_view.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ChronokeeperApp());
}

/// Configuración de controlador para alerta de actualización
final upgrader = Upgrader(
  debugLogging: true, // Comentar en release
  durationUntilAlertAgain: const Duration(minutes: 10),
  countryCode: 'CL'
);

/// Configuración de navegación
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

/// Widget raiz
class ChronokeeperApp extends StatelessWidget {
  const ChronokeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => ChronoViewModel(ChronoService())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Chronokeeper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
