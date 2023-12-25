import 'package:codesofttask1/models/notesmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'tasks.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, isCompleted INTEGER NOT NULL)"
    );
  }

  Future<Notesmodel> insert(Notesmodel notesmodel) async {
    var dbClient = await db;
    await dbClient!.insert('tasks', notesmodel.toMap());
    return notesmodel;
  }

  Future<List<Notesmodel>> getnotelist() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('tasks');
    return queryResult.map((e) => Notesmodel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(Notesmodel notesmodel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'tasks',
      notesmodel.toMap(),
      where: 'id=?',
      whereArgs: [notesmodel.id],
    );
  }
}
