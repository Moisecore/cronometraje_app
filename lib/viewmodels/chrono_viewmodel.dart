import 'package:flutter/foundation.dart';
import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:cronometraje_app/services/chrono_service.dart';

/// ViewModel que maneja el estado de los Chronos.
class ChronoViewModel extends ChangeNotifier {
  final ChronoService _chronoService;

  List<ChronoModel> _chronos = [];
  List<ChronoModel> get chronos => _chronos;

  ChronoViewModel(this._chronoService);
  
  /// Trae todos los Chronos (visibles) de la base de datos y actualiza el state.
  Future<void> fetchChronos() async {
    _chronos = await _chronoService.getChronos();
    notifyListeners();
  }

  /// Agrega un nuevo Chrono y actualiza el state.
  Future<void> addChrono(String name) async {
    final newChrono = ChronoModel(name: name, createdAt: DateTime.now());
    await _chronoService.addChrono(newChrono);
    await fetchChronos(); // Refresca la lista luego de la inserción.
  }

  /// Borra un Chrono y actualiza el state.
  Future<void> deleteChrono(int id) async {
    await _chronoService.deleteChronoPermanently(id);
    await fetchChronos();
  }

  /// Oculta un Chrono y actualiza el state.
  Future<void> hideChrono(int id) async {
    await _chronoService.softDeleteChrono(id);
    await fetchChronos();
  }

  /// Actualiza el estado de un Chrono (0: stopped, 1: running, 2: paused) y el state.
  Future<void> updateChronoState(int id, ChronoState newState) async {
    await _chronoService.updateChronoState(id, newState);
    await fetchChronos();
  }
}