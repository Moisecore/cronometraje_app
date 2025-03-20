import 'package:cronometraje_app/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';

/// Vista de pantalla "Mis Chronos".
/// 
/// Se muestra un botón para crear un nuevo Chrono, y una lista de los Chronos existentes.
class MyChronosView extends StatefulWidget {
  const MyChronosView({super.key});

  @override
  MyChronosViewState createState() => MyChronosViewState();  
}

class MyChronosViewState extends State<MyChronosView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChronoViewModel>(context, listen: false).fetchChronos();
    });
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChronoViewModel>(
      builder: (context, chronoViewModel, child) {
        final chronos = chronoViewModel.chronos;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis Chronos'),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            leading: const Icon(Icons.timer),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), 
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/createChrono'),
                            icon: Icon(Icons.add),
                            label: Text('Crear Chrono'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: chronos.isEmpty
                            ? Center(
                                child: Text(
                                  'No has creado ningún Chrono',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: chronos.length,
                                itemBuilder: (context, index) {
                                  final chrono = chronos[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      title: Text(chrono.name),
                                      subtitle: Text(
                                        'Creado: ${formatDate(chrono.createdAt.toLocal().toString())}',
                                        //'id: ${chrono.id}\nCreado: ${chrono.createdAt.toLocal()}',
                                        //'id: ${chrono.id}\nCreado: ${chrono.createdAt.toLocal()}\nEstado: ${chrono.state.toString().split('.').last}',
                                        //'Creado: ${chrono.createdAt.toLocal()}\nEstado: ${chrono.state.toString().split('.').last}\nEtiquetas: ${chrono.tags.join(', ')}',
                                      ),
                                      onTap: () => context.push('/chrono', extra: chrono),
                                    )
                                  );
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
