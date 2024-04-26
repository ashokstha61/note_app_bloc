import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  static String _databaseName = "note.db";

  static int _databaseVersion = 1;

  static Database? _database;
  static String _tableName = "note";
  static String _tableId = "id";
  static String _tableTitle = "title";
  static String _tableDescription = "description";
  static String _tableCreated = "created_at";
  static String _tableSync = "sync";

  static Future<Database> get db async {
    if (_database == null) {
      final dbPath = await getDatabasesPath();
      _database = await openDatabase(
        "$dbPath/$_databaseName",
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $_tableName ($_tableId TEXT PRIMARY KEY, $_tableTitle TEXT, $_tableDescription TEXT, $_tableCreated INTEGER, $_tableSync INTEGER)',
          );
        },
      );
    }
    return _database!;
  }

  static Future<List<Todo>> fetchNotes() async {
    final instance = await db;
    final temp = await instance.query(_tableName);
    return temp.map((e) => Todo.fromDB(e)).toList();
  }

  static Future<Todo> createNote({
    String? id,
    required String title,
    required String description,
    required DateTime createAt,
  }) async {
    final instance = await db;
    Map<String, dynamic> param = {
      _tableId: id ?? "local-${Uuid().v4()}",
      _tableTitle: title,
      _tableDescription: description,
      _tableCreated: createAt.microsecondsSinceEpoch,
      _tableSync: id != null,
    };
    final _ = await instance.insert(_tableName, param);
    return Todo.fromDB(param);
  }

  static Future<Todo> updateNote({
    required String id,
    required String title,
    required String description,
    required bool sync,
  }) async {
    final instance = await db;
    Map<String, dynamic> param = {
      _tableTitle: title,
      _tableDescription: description,
      _tableSync: sync,
    };
    final _ = await instance
        .update(_tableName, param, where: "id=?", whereArgs: [id]);
    final todo =
        await instance.query(_tableName, where: "id=?", whereArgs: [id]);
    if (todo.isEmpty) {
      throw Exception("No todo list found");
    } else {
      return Todo.fromDB(todo.first);
    }
  }

  static Future<void> deleteNote({
    required String id,
  }) async {
    final instance = await db;

    final _ = await instance.delete(_tableName, where: "id=?", whereArgs: [id]);
  }

  static Future<void> deleteAllNote() async {
    final instance = await db;
    final _ = await instance.delete(_tableName);
  }

  static Future<void> insertAllNote(List<Todo> notes) async {
    final instance = await db;
    for (Todo todo in notes) {
      final _ = await instance.insert(_tableName, todo.toDBData());
    }
  }

  static Future<List<Todo>> getUnSyncData() async {
    final instance = await db;
    final temp= await instance.query(_tableName, where: "$_tableSync =?", whereArgs: [false]);
    return temp.map((r) => Todo.fromDB(r)).toList();
  }
}
