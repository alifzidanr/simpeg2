import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

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
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.*, 
        rj.nama_jabatan AS jabatan_pegawai,
        SUBSTR(ru.nama_unit, INSTR(ru.nama_unit, '-') + 1) AS unit_kerja,
        rs.kode AS status_pegawai,
        bd.nama_bidang AS bidang_diampu,
        sn.status_nikah,
        rg.nama_wilayah AS regional
      FROM t_pegawai AS p
      JOIN t_pegawai_jabatan AS pj ON p.id_pegawai = pj.id_pegawai
      JOIN t_ref_jabatan_pegawai AS rj ON pj.id_ref_jabatan_pegawai = rj.id_ref_jabatan_pegawai
      JOIN t_ref_unit_kerja AS ru ON pj.id_unit_kerja = ru.id_unit_kerja
      JOIN t_ref_status_pegawai AS rs ON pj.id_status_pegawai = rs.id_status_pegawai
      JOIN t_ref_bidang_diampu AS bd ON p.id_bidang_diampu = bd.id_bidang_diampu
      JOIN t_ref_status_nikah AS sn ON p.id_status_nikah = sn.id_status_nikah
      JOIN t_ref_regional AS rg ON p.id_regional = rg.id_regional
      WHERE p.id_pegawai = ?
    ''', [idPegawai]);

    if (result.isNotEmpty) {
      return result.first;
    }
  } catch (e) {
    print('Error fetching employee profile: $e');
  }
  return null;
}

Future<List<Map<String, dynamic>>> getFamilyData(String idPegawai) async {
  final db = await database;
  final result = await db.rawQuery('''
    SELECT pk.nama_lengkap, 
           pk.jenis_kelamin, 
           pk.tempat_lahir, 
           pk.tgl_lahir, 
           rs.status_keluarga, 
           sn.status_nikah, 
           pk.pekerjaan, 
           pk.status_hidup, 
           CASE 
             WHEN pk.tgl_lahir IS NOT NULL 
             THEN strftime('%Y', 'now') - strftime('%Y', pk.tgl_lahir) 
             ELSE NULL 
           END AS usia,
           pk.tunjangan
    FROM t_pegawai_keluarga AS pk
    JOIN t_ref_status_keluarga AS rs ON pk.id_status_keluarga = rs.id_status_keluarga
    JOIN t_ref_status_nikah AS sn ON pk.id_status_nikah = sn.id_status_nikah
    WHERE pk.id_pegawai = ?
  ''', [idPegawai]);

  // Debugging line to check the result of the query
  print('Fetched family data: $result');

  return result;
}


 Future<void> updateEmployeePhoto(String idPegawai, String base64Image) async {
    final db = await database;
    await db.update(
      't_pegawai',
      {'url_foto': base64Image},
      where: 'id_pegawai = ?',
      whereArgs: [idPegawai],
    );
  }

  // Delete photo in the database
  Future<void> deleteEmployeePhoto(String idPegawai) async {
    final db = await database;
    await db.update(
      't_pegawai',
      {'url_foto': null}, // Set url_foto to NULL
      where: 'id_pegawai = ?',
      whereArgs: [idPegawai],
    );
  }

  Future<List<Map<String, dynamic>>> getEducationData(String idPegawai) async {
  final db = await database;
 final result = await db.rawQuery('''
    SELECT 
      rj.kode_jenjang AS Jenjang, 
      pp.gelar AS Gelar,
      pp.nama_prodi AS Prodi,
      pp.nama_lembaga AS Institusi,
      pp.kota_universitas AS Kota,
      rnegara.nama_negara AS Negara,
      pp.tgl_ijazah AS Tanggal_Ijazah,
      pp.akreditasi_prodi AS Akreditasi
    FROM t_pegawai_pendidikan AS pp
    JOIN t_ref_jenjang_pendidikan AS rj ON pp.id_jenjang = rj.id_jenjang_pendidikan
    JOIN t_ref_negara AS rnegara ON pp.negara = rnegara.id_negara
    WHERE pp.id_pegawai = ?
''', [idPegawai]);

  print('Fetched education data: $result');

  return result;
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