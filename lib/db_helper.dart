import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class TodoDB {
  static final TodoDB instance = TodoDB._init();
  static Database? _database;

  TodoDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<int> addTodo(TODOModel todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<TODOModel>> getAllTodos() async {
    final db = await instance.database;
    final result = await db.query('todos', orderBy: 'id DESC');
    return result.map((json) => TODOModel.fromMap(json)).toList();
  }

  Future<int> updateTodo(TODOModel todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
