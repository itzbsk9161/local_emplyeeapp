import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'UserData.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<void> updateUser(UserData user) async {
    final Database db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int userId) async {
    final Database db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            email TEXT,
            first_name TEXT,
            last_name TEXT,
            avatar TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(UserData user) async {
    final Database db = await database;
    await db.insert('users', user.toMap());
  }

  Future<List<UserData>> getUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) {
      return UserData(
        id: maps[index]['id'],
        email: maps[index]['email'],
        firstName: maps[index]['first_name'],
        lastName: maps[index]['last_name'],
        avatar: maps[index]['avatar'],
      );
    });
  }
}
