import 'package:cronometraje_app/utils/formatter.dart';
import 'package:cronometraje_app/viewmodels/chrono_record_viewmodel.dart';
import 'package:cronometraje_app/viewmodels/record_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';

/// Vista de pantalla "Mis registros".
/// 
/// Se muestra una lista de los Chronos existentes que tienen algún tiempo registrado, y el último tiempo guardado de cada uno.
class MyRecordsView extends StatefulWidget {
  const MyRecordsView({super.key});

  @override
  MyRecordsViewState createState() => MyRecordsViewState();  
}

class MyRecordsViewState extends State<MyRecordsView> {
  bool _dataLoaded = false; // Para evitar múltiples llamadas a updateData()

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chronoVM = Provider.of<ChronoViewModel>(context, listen: false);
      final recordVM = Provider.of<RecordViewModel>(context, listen: false);
      final chronoRecordVM = Provider.of<ChronoRecordViewModel>(context, listen: false);

      await chronoVM.fetchChronos();  // Cargar Chronos
      await recordVM.fetchRecords();  // Cargar Registros
      await chronoRecordVM.updateData();  // Asegurar que los datos estén sincronizados
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataLoaded) {
      _dataLoaded = true;  // Asegurar que solo se ejecute una vez
      Future.microtask(() {
        Provider.of<ChronoRecordViewModel>(context, listen: false).updateData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChronoViewModel, RecordViewModel, ChronoRecordViewModel>(
      builder: (context, chronoViewModel, recordViewModel, chronoRecordViewModel, child) {
        final chronos = chronoViewModel.chronos;
        final records = recordViewModel.records;
        final chronosWithRecords = chronoRecordViewModel.chronosWithRecords;
        final mostRecentRecords = chronoRecordViewModel.mostRecentRecords;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis registros'),
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
                            : records.isEmpty
                              ? Center(
                                  child: Text(
                                    'No has registrado ningún tiempo',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : chronosWithRecords.isEmpty
                                ? Center(
                                    child: Text(
                                      'No has registrado ningún tiempo',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: chronosWithRecords.length,
                                    itemBuilder: (context, index) {
                                      final chronoWithRecords = chronosWithRecords[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: Text(chronoWithRecords.name),
                                          subtitle: Text(
                                            //'''id: ${chronoWithRecords.id}\n
                                            '''Creado: ${formatDate(chronoWithRecords.createdAt.toLocal().toString())}\nÚltimo registro: ${formatDuration(mostRecentRecords[chronoWithRecords.id]!.recordedTime)}''',
                                            //'id: ${chronoWithRecords.id}\nCreado: ${chronoWithRecords.createdAt.toLocal()}\nEtiquetas: ${chronoWithRecords.tags.join(', ')}',
                                          ),
                                          onTap: () => context.push('/chrono/records', extra: chronoWithRecords),
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
