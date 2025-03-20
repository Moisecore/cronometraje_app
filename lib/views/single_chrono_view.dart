import 'package:cronometraje_app/services/record_service.dart';
import 'package:cronometraje_app/utils/formatter.dart';
import 'package:cronometraje_app/viewmodels/single_chrono_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Vista de pantalla "Ver Chrono".
/// 
/// Se muestran los datos de un Chrono, y un botón para ir a ver sus tiempos registrados.
class SingleChronoView extends StatelessWidget {
  final ChronoModel chrono;

  const SingleChronoView({super.key, required this.chrono});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SingleChronoViewModel(chrono, RecordService()),
      child: Builder(
        builder: (context) => PopScope(
          canPop: false, // Evita que la vista se cierre automáticamente.
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final viewModel = Provider.of<SingleChronoViewModel>(context, listen: false);
            bool canExit = await viewModel.onBackPressed(context);
            if (canExit) {
              Navigator.of(context).pop();
            }
          },
          child: Consumer<SingleChronoViewModel>(
            builder: (context, viewModel, child) {
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
                          Text('Nombre: ${viewModel.chrono.name}'),
                          Text('Fecha de creación: ${formatDate(viewModel.chrono.createdAt.toLocal().toString())}'),
                          SizedBox(height: 20),
                          Text(
                            formatDuration(viewModel.elapsedTime),
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          if (viewModel.chrono.state == ChronoState.detenido && viewModel.elapsedTime == (Duration(milliseconds: 0)))
                            ElevatedButton.icon(
                              onPressed: viewModel.startChrono,
                              icon: Icon(Icons.play_arrow),
                              label: Text('Iniciar'),
                            ),
                          if (viewModel.chrono.state == ChronoState.andando)
                            ElevatedButton.icon(
                              onPressed: () {
                                viewModel.stopChrono(context);
                              },
                              icon: Icon(Icons.stop),
                              label: Text('Detener'),
                            ),
                          if (viewModel.chrono.state == ChronoState.detenido && viewModel.elapsedTime > (Duration(milliseconds: 0)))
                            ElevatedButton.icon(
                              onPressed: viewModel.resetChrono,
                              icon: Icon(Icons.refresh),
                              label: Text('Reestablecer'),
                            ),
                          SizedBox(height: 20),
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
          ),
        )
      )
    );
  }

}