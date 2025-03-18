import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';
import 'package:cronometraje_app/models/chrono_model.dart';

/// Vista de pantalla "Mis Chronos".
/// 
/// Se muestra un botón para crear un nuevo chrono, y una lista de los chronos existentes.
class MyChronosView extends StatelessWidget {
  const MyChronosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chronokeeper'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: const Icon(Icons.timer),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  //Provider.of<ChronoViewModel>(context, listen: false).addChrono('Nuevo Chrono');
                },
                icon: Icon(Icons.add),
                label: Text('Crear Chrono'),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ChronoViewModel>(
              builder: (context, chronoViewModel, child) {
                final chronos = chronoViewModel.chronos;
                if (chronos.isEmpty) {
                  return Center(
                    child: Text(
                      'No has creado ningún Chrono',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: chronos.length,
                  itemBuilder: (context, index) {
                    final chrono = chronos[index];
                    return ListTile(
                      title: Text(chrono.name),
                      subtitle: Text(
                        'Creado: ${chrono.createdAt.toLocal()}\nEstado: ${chrono.state.toString().split('.').last}\nEtiquetas: ${chrono.tags.join(', ')}',
                      ),
                      onTap: () {
                        /**Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChronoDetailView(chrono: chrono),
                          ),
                        );*/
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}