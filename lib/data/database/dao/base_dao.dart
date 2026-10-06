import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDao {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();

    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      'super_gacha_hero.db',
    );

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(
  Database db,
  int version,
) async {
  await db.execute('''
    CREATE TABLE agentes (
      id INTEGER PRIMARY KEY,
      data TEXT NOT NULL
    )
  ''');

  await db.execute('''
    CREATE TABLE esquadrao (
      id INTEGER PRIMARY KEY,
      data TEXT NOT NULL
    )
  ''');
  }
  Future<void> _onUpgrade(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  if (oldVersion < 2) {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS esquadrao (
        id INTEGER PRIMARY KEY,
        data TEXT NOT NULL
      )
    ''');
  }
}
}