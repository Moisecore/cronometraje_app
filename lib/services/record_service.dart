import 'package:cronometraje_app/models/record_model.dart';
import 'package:cronometraje_app/database/database_helper.dart';

/// Servicio para manejar los registros en base de datos.
class RecordService {
  
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Inserta un registro en la tabla 'records'.
  Future<int> addRecord(RecordModel record) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'records', 
      record.toMap()
    );
  }

  /// Obtiene los registros de la tabla 'records' que están visibles (no han sido soft-deleted).
  Future<List<RecordModel>> getRecordsByChrono(int chronoId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
      await db.query(
        'records', 
        where: 'chronoId = ? AND hidden = 0', 
        whereArgs: [chronoId]
      );
    return List.generate(maps.length, (i) {
      return RecordModel.fromMap(maps[i]);
    });
  }

  /// Obtiene los registros de la tabla 'records' que no están visibles (han sido soft-deleted).
  Future<List<RecordModel>> getHiddenRecordsByChrono(int chronoId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
      await db.query(
        'records', 
        where: 'chronoId = ? AND hidden = 1', 
        whereArgs: [chronoId]
      );
    return List.generate(maps.length, (i) {
      return RecordModel.fromMap(maps[i]);
    });
  }

  /// Oculta un registro (cambia su valor 'hidden' a 1 en la tabla 'records').
  Future<int> softDeleteRecord(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'records', 
      {'hidden': 1}, 
      where: 'id = ?', 
      whereArgs: [id]);
  }

  /// Recupera un registro oculto (vuelve a ser visible, es decir, cambia su valor 'hidden' a 0 en la tabla 'records').
  Future<int> restoreRecord(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'records', 
      {'hidden': 0}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  /// Elimina un registro de la tabla 'records' (no incluye borrar sus relaciones).
  Future<int> deleteRecordPermanently(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'records', 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }
}
