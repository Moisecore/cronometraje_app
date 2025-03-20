import 'package:cronometraje_app/utils/formatter.dart';
import 'package:cronometraje_app/viewmodels/record_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:provider/provider.dart';

/// Vista de pantalla "Ver registros de Chrono".
/// 
/// Se muestran los datos de un Chrono, y sus tiempos registrados.
class SingleChronoRecordsView extends StatefulWidget {
  final ChronoModel chrono;

  const SingleChronoRecordsView({super.key, required this.chrono});

  @override
  SingleChronoRecordsViewState createState() => SingleChronoRecordsViewState();
}

class SingleChronoRecordsViewState extends State<SingleChronoRecordsView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordViewModel>(context, listen: false).fetchRecordsByChrono(widget.chrono.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordViewModel = Provider.of<RecordViewModel>(context);
    final records = recordViewModel.filteredRecords;
    final lastRecord = records.isNotEmpty ? records.last : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver registros de Chrono'),
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
                  Text(widget.chrono.name),
                  const SizedBox(height: 16),
                  Text('Fecha de creación: ${formatDate(widget.chrono.createdAt.toLocal().toString())}'),
                  const SizedBox(height: 16),
                  if (lastRecord != null)
                    Text('Último tiempo registrado: ${formatDuration(lastRecord.recordedTime)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: records.isEmpty
                        ? Center(
                            child: Text(
                              'No has registrado ningún tiempo',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              final record = records[index];
                              return Card(
                                child: ListTile(
                                  title: Text('Tiempo: ${formatDuration(record.recordedTime)}'),
                                  subtitle: Text('Fecha: ${formatDate(record.createdAt.toLocal().toString())}'),
                                  trailing: record.comment != null ? Text(record.comment!) : null,
                                ),
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