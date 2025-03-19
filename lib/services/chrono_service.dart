import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cronometraje_app/models/chrono_model.dart';

/// Servicio para manejar la base de datos.
class ChronoService {
  static final ChronoService _instance = ChronoService._internal();
  factory ChronoService() => _instance;

  Database? _database;

  ChronoService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Inicia la base de datos y crea la tabla 'chronos'.
  /// 
  /// version: 1 - contiene la tabla 'chronos'.
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // En caso de querer app para iOS, usar 'path_provider'.
    final path = join(dbPath, 'chronokeeper.db');
    
    // Descomentar para resetear base de datos.
    // databaseFactory.deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1, // Aumentar en 1 al agregar nuevas tablas.
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE chronos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            createdAt TEXT,
            state INTEGER,
            tags TEXT,
            hidden INTEGER DEFAULT 0
          )''',
        );
      },
    );
  }

  /// Inserta un Chrono en la tabla 'chronos'.
  Future<int> addChrono(ChronoModel chrono) async {
    final db = await database;
    return await db.insert('chronos', chrono.toMap());
  }

  /// Obtiene los Chronos de la tabla 'chronos' que están visibles (no han sido soft-deleted).
  Future<List<ChronoModel>> getChronos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chronos', where: 'hidden = ?', whereArgs: [0]);
    return List.generate(maps.length, (i) => ChronoModel.fromMap(maps[i]));
  }

  /// Obtiene los Chronos de la tabla 'chronos' que no están visibles (han sido soft-deleted).
  Future<List<ChronoModel>> getHiddenChronos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chronos', where: 'hidden = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) => ChronoModel.fromMap(maps[i]));
  }

  /// Actualiza los valores de un Chrono en la tabla 'chronos'.
  Future<int> updateChrono(ChronoModel chrono) async {
    final db = await database;
    return await db.update(
      'chronos',
      chrono.toMap(),
      where: 'id = ?',
      whereArgs: [chrono.id],
    );
  }

  /// Actualiza el estado de un Chrono (stopped, running, paused) en la tabla 'chronos'.
  Future<int> updateChronoState(int id, ChronoState newState) async {
    final db = await database;
    return await db.update(
      'chronos', 
      {'state': newState.index},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Oculta un Chrono (cambia su valor 'hidden' a 1 en la tabla 'chronos').
  Future<int> softDeleteChrono(int id) async {
    final db = await database;
    return await db.update(
      'chronos',
      {'hidden': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Recupera un Chrono oculto (vuelve a ser visible, es decir, cambia su valor 'hidden' a 0 en la tabla 'chronos').
  Future<int> restoreChrono(int id) async {
    final db = await database;
    return await db.update(
      'chronos',
      {'hidden': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina un Chrono de la tabla 'chronos' (no incluye borrar sus relaciones).
  Future<int> deleteChrono(int id) async {
    final db = await database;
    return await db.delete(
      'chronos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}