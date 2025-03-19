import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Vista de pantalla principal.
/// 
/// Se muestran dos botones: ver los Chronos y ver los registros.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Pendiente: agregar logo a la barra.
        title: const Text('Chronokeeper'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: const Icon(Icons.timer),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => context.push('/myChronos'),
                  child: const Text('Mis Chronos'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => context.push('/myRecords'),
                  child: const Text('Mis registros'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
