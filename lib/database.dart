import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'item.dart';

class DBProvider {
  DBProvider._privateConstructor();
  static final DBProvider db = DBProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'shopping_list.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE shopping_list (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tarefa TEXT NOT NULL,
          isChecked INTEGER NOT NULL
        )
      ''');
      },
    );
  }

// OPERAÇÕES CRUD

  newItem(Item item) async {
    final db = await database;
    var res = await db.insert("shopping_list", item.toMap());
    return res;
  }

  Future<List<Item>> getAllItems() async {
    final db = await database;
    var res = await db.query("shopping_list");
    List<Item> list =
        res.isNotEmpty ? res.map((c) => Item.fromMap(c)).toList() : [];
    return list;
  }

  Future<Item?> getItem(int id) async {
    final db = await database;
    var res = await db.query("shopping_list", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Item.fromMap(res.first) : null;
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    var res = await db.update("shopping_list", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  deleteItem(int id) async {
    final db = await database;
    db.delete("shopping_list", where: "id = ?", whereArgs: [id]);
  }
}
