import 'dart:async';
import 'package:cronometraje_app/models/record_model.dart';
import 'package:cronometraje_app/services/record_service.dart';
import 'package:cronometraje_app/models/chrono_model.dart';
import 'package:cronometraje_app/utils/formatter.dart';
import 'package:flutter/material.dart';

class SingleChronoViewModel extends ChangeNotifier {
  final ChronoModel chrono;
  final RecordService recordService;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  bool _hasElapsed = false;

  SingleChronoViewModel(this.chrono, this.recordService) {
    _resetIfNeeded(); // Asegura que el cronómetro se reinicie si fue interrumpido
    _loadElapsedTime();
  }

  void _resetIfNeeded() {
  if (chrono.state == ChronoState.andando) {
    chrono.state = ChronoState.detenido;
    _elapsedTime = Duration.zero;
    _hasElapsed = false;
    //recordService.deleteRecordsByChronoId(chrono.id!); // Borra registros antiguos
  }
}

  Duration get elapsedTime => _elapsedTime;
  bool get hasElapsed => _hasElapsed;

  Future<void> _loadElapsedTime() async {
    if (chrono.state == ChronoState.detenido) {
      _elapsedTime = Duration.zero;
      _hasElapsed = false;
    } else {
      final records = await recordService.getRecordsByChrono(chrono.id!);
      _elapsedTime = records.isNotEmpty ? records.last.recordedTime : Duration.zero;
      _hasElapsed = _elapsedTime > Duration.zero;
    }
    notifyListeners();
  }

  void startChrono() {
    if (chrono.state == ChronoState.andando) return;
    chrono.state = ChronoState.andando;
    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      _elapsedTime = DateTime.now().difference(_startTime!);
      notifyListeners();
    });
  }

  Future<void> stopChrono(BuildContext context) async {
    if (chrono.state != ChronoState.andando) return;
    chrono.state = ChronoState.detenido;
    _timer?.cancel();
    _elapsedTime = DateTime.now().difference(_startTime!);
    DateTime createdAt = DateTime.now();
    await recordService.addRecord(RecordModel(
      createdAt: createdAt,
      recordedTime: _elapsedTime,
      chronoId: chrono.id!,
    ));
    _hasElapsed = true;
    await onChronoStopped(context);
    notifyListeners();
  }

  Future<void> resetChrono() async {
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    _startTime = null;
    _hasElapsed = false;
    chrono.state = ChronoState.detenido;
    //await recordService.deleteRecordsByChronoId(chrono.id!);
    notifyListeners();
  }

  Future<bool> onBackPressed(BuildContext context) async {
    if (chrono.state == ChronoState.andando) {
      bool? confirmExit = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Salir"),
            content: Text("Si sales ahora, el cronómetro se detendrá y no se guardará el tiempo transcurrido. ¿Estás seguro?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Salir"),
              ),
            ],
          );
        },
      );
      return confirmExit ?? false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Muestra el pop-up de confirmación
  Future<void> onChronoStopped(BuildContext context) async {
    final formattedTime = formatDuration(_elapsedTime); // Formatea el tiempo cronometrado
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Registro guardado"),
          content: Text("Chrono '${chrono.name}': el tiempo $formattedTime se ha registrado exitosamente con fecha ${formatDate(chrono.createdAt.toLocal().toString())}."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

}
