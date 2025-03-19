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

  ChronoRecordViewModel(this._chronoViewModel, this._recordViewModel);

  /// Encuentra todos los Chronos que tienen algún registro de tiempo asociado.
  Future<void> findChronosWithRecords() async {
    _chronosWithRecords = _chronoViewModel.chronos.where((chrono) =>
      _recordViewModel.records.any((record) => record.chronoId == chrono.id)).toList();
    notifyListeners();
  }

  /// Encuentra el registro de tiempo más reciente para cada Chrono.
  Future<void> findMostRecentRecordsPerChrono() async {
    for(var record in _recordViewModel.records) {
      if (!mostRecentRecords.containsKey(record.chronoId) || 
          record.createdAt.isAfter(mostRecentRecords[record.chronoId]!.createdAt)) {
        _mostRecentRecords[record.chronoId] = record;
      }
    }
    notifyListeners();
  }

}
