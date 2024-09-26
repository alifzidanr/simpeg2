import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // This provides access to File

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'data.db');
    ByteData data = await rootBundle.load('assets/data.db');
    List<int> bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);
    return await openDatabase(path);
  }

  // Count employees with specific status
  Future<int> getCountByStatus(int status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM t_pegawai WHERE id_status_keaktifan = ?',
      [status],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Retrieve counts for specific id_status_kepegawaian (1, 2, 3, 4, 10)
  Future<List<int>> getStatusCounts() async {
    final db = await database;
    List<int> counts = [];
    List<int> ids = [1, 2, 3, 4, 10];

    for (int id in ids) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM t_pegawai WHERE id_status_kepegawaian = ?',
        [id],
      );
      counts.add(Sqflite.firstIntValue(result) ?? 0);
    }

    return counts;
  }

  Future<Map<String, dynamic>?> getEmployeeProfile(String idPegawai) async {
  try {
    final db = await database; // Get the database instance
    final result = await db.query(
      't_pegawai', // Make sure this is the correct table name
      where: 'id_pegawai = ?', // Make sure this matches your database schema
      whereArgs: [idPegawai],
    );

    print('Query result: $result'); // Print the result of the query

    if (result.isNotEmpty) {
      return result.first; // Return the first record
    }
  } catch (e) {
    print('Error fetching employee profile: $e'); // Log any errors
  }
  return null; // Return null if no data found or an error occurred
}



  // Updated login function to use id_pegawai instead of nip
  Future<bool> login(String idPegawai, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT * FROM t_pegawai WHERE id_pegawai = ? AND password = ?',
      [idPegawai, password],
    );
    return results.isNotEmpty;
  }
}
