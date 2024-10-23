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
      LEFT JOIN t_pegawai_jabatan AS pj ON p.id_pegawai = pj.id_pegawai
      LEFT JOIN t_ref_jabatan_pegawai AS rj ON pj.id_ref_jabatan_pegawai = rj.id_ref_jabatan_pegawai
      LEFT JOIN t_ref_unit_kerja AS ru ON pj.id_unit_kerja = ru.id_unit_kerja
      LEFT JOIN t_ref_status_pegawai AS rs ON pj.id_status_pegawai = rs.id_status_pegawai
      LEFT JOIN t_ref_bidang_diampu AS bd ON p.id_bidang_diampu = bd.id_bidang_diampu
      LEFT JOIN t_ref_status_nikah AS sn ON p.id_status_nikah = sn.id_status_nikah
      LEFT JOIN t_ref_regional AS rg ON p.id_regional = rg.id_regional
      WHERE p.id_pegawai = ?
    ''', [idPegawai]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      print('No profile data found for id_pegawai: $idPegawai');
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

Future<List<Map<String, dynamic>>> getCareerData(String idPegawai) async {
  final db = await database;
  final result = await db.rawQuery('''
    SELECT 
      pj.file_jabatan,
      pj.no_sk,
      pj.hal,
      pj.tgl_sk,
      pj.tgl_berlaku,
      pj.tgl_sd,
      rj.nama_jabatan AS jabatan,
      ru.nama_unit AS unit_kerja,
      pj.status_aktif
    FROM t_pegawai_jabatan AS pj
    JOIN t_ref_jabatan_pegawai AS rj ON pj.id_ref_jabatan_pegawai = rj.id_ref_jabatan_pegawai
    JOIN t_ref_unit_kerja AS ru ON pj.id_unit_kerja = ru.id_unit_kerja
    WHERE pj.id_pegawai = ?
  ''', [idPegawai]);

  return result;
}

Future<List<Map<String, dynamic>>> getGolonganData(String idPegawai) async {
  final db = await database;
  final result = await db.rawQuery('''
    SELECT
      pg.file_golongan,
      pg.no_sk,
      pg.hal,
      pg.tgl_sk,
      pg.tgl_berlaku,
      pg.tgl_habis,
      rg.golongan,         -- This will show the name of golongan
      rg.pangkat,          -- This will show the name of pangkat
      pg.status_aktif
    FROM t_pegawai_golongan AS pg
    JOIN t_ref_golongan AS rg ON pg.id_golongan = rg.id_ref_golongan  -- Ensure you're joining on the correct columns
    WHERE pg.id_pegawai = ?
''', [idPegawai]);

  return result;
}

// Add this method for updating the password
  Future<void> updatePassword(String idPegawai, String newPassword) async {
    final db = await database;
    await db.update(
      't_pegawai',
      {'password': newPassword},  
      where: 'id_pegawai = ?',     
      whereArgs: [idPegawai],      
    );
  }

Future<String?> getIdPegawaiByNip(String nip) async {
  final db = await database;
  final result = await db.rawQuery(
    'SELECT id_pegawai FROM t_pegawai WHERE nip = ?',
    [nip],
  );

  if (result.isNotEmpty) {
    // Cast id_pegawai to String (if it's stored as an int, convert to String)
    return result.first['id_pegawai'].toString();
  }

  return null;
}


// Updated login function to use id_pegawai instead of nip
Future<bool> login(String idPegawai, String password) async {
  try {
    final db = await database;
    print('Checking login for id_pegawai: $idPegawai with password: $password');
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT * FROM t_pegawai WHERE id_pegawai = ? AND password = ?',
      [int.tryParse(idPegawai) ?? idPegawai, password],  // Convert idPegawai to int if possible
    );

    print('Query results: $results');
    return results.isNotEmpty;
  } catch (e) {
    print('Error in login query: $e');
    return false;
  }
}



}
