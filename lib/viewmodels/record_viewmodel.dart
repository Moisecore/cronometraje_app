import 'package:cronometraje_app/models/record_model.dart';
import 'package:cronometraje_app/services/record_service.dart';
import 'package:flutter/foundation.dart';

/// ViewModel que maneja el estado de los registros.
class RecordViewModel extends ChangeNotifier {
  final RecordService _recordService;

  List<RecordModel> _allRecords = [];  // 🔹 Guarda todos los registros
  List<RecordModel> _filteredRecords = []; // 🔹 Guarda registros filtrados

  List<RecordModel> get records => _allRecords; 
  List<RecordModel> get filteredRecords => _filteredRecords;

  RecordViewModel(this._recordService);
  
  /// Trae todos los registros (visibles) de la base de datos y actualiza el state.
  Future<void> fetchRecords() async {
    _allRecords = await _recordService.getRecords();
    //print("✅ Registros cargados en ViewModel: ${_allRecords.length}");
    notifyListeners();
  }

  /// Trae todos los registros (visibles) de un Chrono específico y actualiza el state.
  Future<void> fetchRecordsByChrono(int chronoId) async {
    _filteredRecords = await _recordService.getRecordsByChrono(chronoId);
    notifyListeners();
  }

  /// Filtra la lista de todos los registros para guardar los de un Chrono específico y actualiza el state.
  Future<void> filterRecordsByChrono(int chronoId) async {
    _filteredRecords = _allRecords.where((r) => r.chronoId == chronoId).toList();
    notifyListeners();
  }

  /// Agrega un nuevo registro y actualiza el state.
  Future<void> addRecord(int chronoId, Duration time) async {
    final newRecord = RecordModel(chronoId: chronoId, createdAt: DateTime.now(), recordedTime: time);
    await _recordService.addRecord(newRecord);
    await fetchRecords(); // Refresca la lista luego de la inserción.
  }

  /// Borra un registro y actualiza el state.
  Future<void> deleteRecord(int id) async {
    await _recordService.deleteRecordPermanently(id);
    await fetchRecords();
  }

  /// Oculta un registro y actualiza el state.
  Future<void> hideRecord(int id) async {
    await _recordService.softDeleteRecord(id);
    await fetchRecords();
  }

}