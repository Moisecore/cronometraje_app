import 'package:cronometraje_app/models/record_model.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';
import 'package:cronometraje_app/viewmodels/record_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:cronometraje_app/models/chrono_model.dart';

/// ViewModel que maneja el estado de los Chronos con registros.
class ChronoRecordViewModel extends ChangeNotifier {

  final ChronoViewModel _chronoViewModel;
  final RecordViewModel _recordViewModel;

  List<ChronoModel> _chronosWithRecords = [];
  List<ChronoModel> get chronosWithRecords => _chronosWithRecords;

  final Map<int, RecordModel> _mostRecentRecords = {};
  Map<int, RecordModel> get mostRecentRecords => _mostRecentRecords;

  ChronoRecordViewModel(this._chronoViewModel, this._recordViewModel){
    // Escuchar cambios en ChronoViewModel y RecordViewModel
    _chronoViewModel.addListener(updateData);
    _recordViewModel.addListener(updateData);
  }

  Future<void> updateData() async {
    //print("🔄 updateData() ejecutado");
    final previousChronosWithRecords = List.from(_chronosWithRecords);
    final previousMostRecentRecords = Map.from(_mostRecentRecords);
    //print("📊 Chronos disponibles en ViewModel: ${_chronoViewModel.chronos.length}");
    //print("📊 Registros disponibles en ViewModel: ${_recordViewModel.records.length}");
    await findChronosWithRecords();
    await findMostRecentRecordsPerChrono();
    // Solo notifica si los datos realmente cambiaron
    if (!listEquals(previousChronosWithRecords, _chronosWithRecords) ||
        !mapEquals(previousMostRecentRecords, _mostRecentRecords)) {
      notifyListeners();
    }
  }

  /// Encuentra todos los Chronos que tienen algún registro de tiempo asociado.
  Future<void> findChronosWithRecords() async {
    _chronosWithRecords = _chronoViewModel.chronos.where((chrono) =>
      _recordViewModel.records.any((record) => record.chronoId == chrono.id)).toList();
    //print("🔍 Chronos con registros encontrados: ${_chronosWithRecords.length}");
    notifyListeners();
  }

  /// Encuentra el registro de tiempo más reciente para cada Chrono.
  Future<void> findMostRecentRecordsPerChrono() async {
    _mostRecentRecords.clear();
    for (var record in _recordViewModel.records) {
      if (!_mostRecentRecords.containsKey(record.chronoId) || 
          record.createdAt.isAfter(_mostRecentRecords[record.chronoId]!.createdAt)) {
        _mostRecentRecords[record.chronoId] = record;
      }
    }
    //print("📌 Últimos registros por Chrono: ${_mostRecentRecords.length}");
    notifyListeners();
  }

}
