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
  Widget build(BuildContext context) {
    final chronoViewModel = Provider.of<ChronoViewModel>(context);
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
                          return ListTile(
                            title: Text(chrono.name),
                            subtitle: Text(
                              'id: ${chrono.id}\nCreado: ${chrono.createdAt.toLocal()}\nEstado: ${chrono.state.toString().split('.').last}',
                              //'Creado: ${chrono.createdAt.toLocal()}\nEstado: ${chrono.state.toString().split('.').last}\nEtiquetas: ${chrono.tags.join(', ')}',
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
}