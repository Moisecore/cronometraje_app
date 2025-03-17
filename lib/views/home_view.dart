import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Vista de pantalla principal
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Pendiente: agregar logo a la barra
        title: const Text('Chronokeeper'),
        centerTitle: true,
        leading: const Icon(Icons.timer),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/myChronos'),
              child: const Text('Mis Chronos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Pendiente: agregar navegación a MyRecordsView
              child: const Text('Mis registros'),
            ),
          ],
        ),
      ),
    );
  }
}
