import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert(
      'notes',
      note.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ (all)
  Future<List<Note>> getNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
