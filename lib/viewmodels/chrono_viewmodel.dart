import 'package:flutter/foundation.dart';
import '../models/chrono_model.dart';
import '../services/chrono_service.dart';

/// ViewModel que maneja el estado de los Chronos.
class ChronoViewModel extends ChangeNotifier {
  final ChronoService _chronoService;

  List<ChronoModel> _chronos = [];
  List<ChronoModel> get chronos => _chronos;

  ChronoViewModel(this._chronoService);
  /**
  /// Fetches all Chronos from the database and updates the state.
  Future<void> fetchChronos() async {
    _chronos = await _chronoService.getAllChronos();
    notifyListeners();
  }

  /// Adds a new Chrono and updates the state.
  Future<void> addChrono(String name) async {
    final newChrono = ChronoModel(name: name, createdAt: DateTime.now());
    await _chronoService.insertChrono(newChrono);
    await fetchChronos(); // Refresh the list after insertion
  }

  /// Deletes a Chrono and updates the state.
  Future<void> deleteChrono(int id) async {
    await _chronoService.deleteChrono(id);
    await fetchChronos();
  }

  /// Updates the state of a Chrono (start, pause, stop).
  Future<void> updateChronoState(int id, ChronoState newState) async {
    await _chronoService.updateChronoState(id, newState);
    await fetchChronos();
  }*/
}