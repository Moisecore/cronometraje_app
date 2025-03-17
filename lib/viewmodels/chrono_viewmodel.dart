import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:cronometraje_app/services/chrono_service.dart';
import 'package:flutter/material.dart';

// Chrono ViewModel (Logic for managing timers)
class ChronoViewmodel extends ChangeNotifier {
  /**late ChronoService _chronoService;
  List<ChronoModel> _chronos = [];

  ChronoViewModel(chronoService) {
    chronoService.chronoStream.listen((chronos) {
      _chronos = chronos;
      notifyListeners();
    });
  }

  List<ChronoModel> get chronos => _chronos;

  void addChrono(String name, int duration) {
    _chronoService.addChrono(ChronoModel(name: name, duration: duration));
  }

  void startChrono(int index) {
    _chronoService.startChrono(index);
  }

  void stopChrono(int index) {
    _chronoService.stopChrono(index);
  }*/
}