import 'package:flutter/material.dart';
import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:go_router/go_router.dart';

/// Vista de pantalla "Ver Chrono".
/// 
/// Se muestran los datos de un Chrono, y un botón para ir a ver sus tiempos registrados.
class SingleChronoView extends StatelessWidget {
  final ChronoModel chrono;

  const SingleChronoView({super.key, required this.chrono});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Chrono'),
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
                Text('Nombre: ${chrono.name}'),
                const SizedBox(height: 20),
                Text('Fecha de creación: ${chrono.createdAt}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.push('/chrono/records', extra: chrono);
                  },
                  child: Text('Ver tiempos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
