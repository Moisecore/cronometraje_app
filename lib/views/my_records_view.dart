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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChronoViewModel>(context, listen: false).fetchChronos();
      Provider.of<RecordViewModel>(context, listen: false).fetchRecords();
      Provider.of<ChronoRecordViewModel>(context, listen: false).findChronosWithRecords();
      Provider.of<ChronoRecordViewModel>(context, listen: false).findMostRecentRecordsPerChrono();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chronoViewModel = Provider.of<ChronoViewModel>(context);
    final recordViewModel = Provider.of<RecordViewModel>(context);
    final chronoRecordViewModel = Provider.of<ChronoRecordViewModel>(context);
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
                                        '''id: ${chronoWithRecords.id}\n
                                        Creado: ${chronoWithRecords.createdAt.toLocal()}\n
                                        Último registro: ${mostRecentRecords[chronoWithRecords.id]!.recordedTime}}''',
                                        //'id: ${chronoWithRecords.id}\nCreado: ${chronoWithRecords.createdAt.toLocal()}\nEtiquetas: ${chronoWithRecords.tags.join(', ')}',
                                      ),
                                      onTap: () => context.go('/chrono/records', extra: chronoWithRecords),
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
}
