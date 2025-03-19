import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Clase para manejar la base de datos.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Inicia la base de datos y crea la tabla 'chronos'.
  /// 
  /// version: 1 - contiene la tabla 'chronos'.
  ///          2 - se agrega la tabla 'records'.
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // En caso de querer app para iOS, usar 'path_provider'.
    final path = join(dbPath, 'chronokeeper.db');

    // Descomentar para resetear base de datos.
    //databaseFactory.deleteDatabase(path);

    return await openDatabase(
      path,
      version: 2, // Aumentar en 1 al agregar nuevas tablas.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chronos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            createdAt TEXT,
            state INTEGER,
            tags TEXT,
            hidden INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chronoId INTEGER,
            createdAt TEXT,
            duration INTEGER,
            comment TEXT,
            hidden INTEGER DEFAULT 0,
            FOREIGN KEY (chronoId) REFERENCES chronos (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}