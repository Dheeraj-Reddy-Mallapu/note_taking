import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLite {
  static Future createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, content TEXT, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('calculator.db', version: 1,
        onCreate: (sql.Database db, version) async {
      await createTables(db);
    });
  }

  static Future<int> createItem(String title, String? content) async {
    final db = await SQLite.db();

    final data = {'title': title, 'content': content};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLite.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLite.db();
    return db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? content) async {
    final db = await SQLite.db();

    final data = {
      'title': title,
      'content': content,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLite.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }
}
