import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

class DBService {
  static Database? _db;

  // Init
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'crm_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //User table
        await db.execute('''
        CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT
        )
        ''');

        // Cart table
        await db.execute('''
        CREATE TABLE carts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userName TEXT,
          product TEXT,
          amount REAL,
          status TEXT,
          time TEXT
        )
        ''');

        // Call log table
        await db.execute('''
        CREATE TABLE calls(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cartId INTEGER,
          status TEXT,
          duration INTEGER,
          note TEXT,
          createdAt TEXT
        )
        ''');

        //Notes table
        await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cartId INTEGER,
          note TEXT,
          createdAt TEXT
        )
        ''');
      },
    );
  }

  // User
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.delete('user');
    await db.insert('user', user);
  }

  static Future<UserModel?> getUser() async {
    final db = await database;
    final res = await db.query('user');

    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first); // 🔥 convert here
    }
    return null;
  }

  static Future<void> logout() async {
    final db = await database;
    await db.delete('user');
  }

  // Cart
  static Future<int> insertCart(Map<String, dynamic> cart) async {
    final db = await database;
    return await db.insert('carts', cart);
  }

  static Future<List<Map<String, dynamic>>> getCarts() async {
    final db = await database;
    return await db.query('carts', orderBy: "id DESC");
  }

  static Future<void> updateCartStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'carts',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Call
  static Future<void> insertCall(Map<String, dynamic> call) async {
    final db = await database;
    await db.insert('calls', call);
  }

  static Future<List<Map<String, dynamic>>> getCalls() async {
    final db = await database;
    return await db.query('calls', orderBy: "id DESC");
  }

  // Notes
  static Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert('notes', note);
  }

  static Future<List<Map<String, dynamic>>> getNotes(int cartId) async {
    final db = await database;
    return await db.query('notes', where: 'cartId = ?', whereArgs: [cartId]);
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('carts');
    await db.delete('calls');
    await db.delete('notes');
  }
}
