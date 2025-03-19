import 'package:cronometraje_app/database/database_helper.dart';
import 'package:cronometraje_app/models/chrono_model.dart';

/// Servicio para manejar los Chronos en base de datos.
class ChronoService {

  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Inserta un Chrono en la tabla 'chronos'.
  Future<int> addChrono(ChronoModel chrono) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'chronos', 
      chrono.toMap()
    );
  }

  /// Obtiene los Chronos de la tabla 'chronos' que están visibles (no han sido soft-deleted).
  Future<List<ChronoModel>> getChronos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = 
      await db.query(
        'chronos', 
        where: 'hidden = ?', 
        whereArgs: [0]
      );
    return List.generate(maps.length, (i) => ChronoModel.fromMap(maps[i]));
  }

  /// Obtiene los Chronos de la tabla 'chronos' que no están visibles (han sido soft-deleted).
  Future<List<ChronoModel>> getHiddenChronos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = 
      await db.query(
        'chronos', 
        where: 'hidden = ?', 
        whereArgs: [1]
      );
    return List.generate(maps.length, (i) => ChronoModel.fromMap(maps[i]));
  }

  /// Actualiza los valores de un Chrono en la tabla 'chronos'.
  Future<int> updateChrono(ChronoModel chrono) async {
    final db = await _dbHelper.database;
    return await db.update(
      'chronos',
      chrono.toMap(),
      where: 'id = ?',
      whereArgs: [chrono.id],
    );
  }

  /// Actualiza el estado de un Chrono (stopped, running, paused) en la tabla 'chronos'.
  Future<int> updateChronoState(int id, ChronoState newState) async {
    final db = await _dbHelper.database;
    return await db.update(
      'chronos', 
      {'state': newState.index},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Oculta un Chrono (cambia su valor 'hidden' a 1 en la tabla 'chronos').
  Future<int> softDeleteChrono(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'chronos',
      {'hidden': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Recupera un Chrono oculto (vuelve a ser visible, es decir, cambia su valor 'hidden' a 0 en la tabla 'chronos').
  Future<int> restoreChrono(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'chronos',
      {'hidden': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina un Chrono de la tabla 'chronos' (no incluye borrar sus relaciones).
  Future<int> deleteChronoPermanently(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'chronos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}