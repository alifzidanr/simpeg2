import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';
import 'package:data_table_2/data_table_2.dart';

class FamilyPage extends StatelessWidget {
  final String idPegawai;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FamilyPage({required this.idPegawai});

  Future<List<Map<String, dynamic>>> _fetchFamilyData() async {
    return await DatabaseHelper.instance.getFamilyData(idPegawai);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Data Keluarga'),
      drawer: buildDrawer(context, idPegawai),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchFamilyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> familyData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 1200, // Set a fixed width for the table
                child: DataTable2(
                  columnSpacing: 12,
                  minWidth: 800,
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Nama Lengkap')),
                    DataColumn(label: Text('Jenis Kelamin')),
                    DataColumn(label: Text('Tempat Lahir')),
                    DataColumn(label: Text('Tanggal Lahir')),
                    DataColumn(label: Text('Status Keluarga')),
                    DataColumn(label: Text('Status Nikah')),
                    DataColumn(label: Text('Pekerjaan')),
                    DataColumn(label: Text('Status Hidup')),
                    DataColumn(label: Text('Usia')),
                    DataColumn(label: Text('Tunjangan')),
                  ],
                  rows: List.generate(familyData.length, (index) {
                    final item = familyData[index];
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())), // No
                        DataCell(Text(item['nama_lengkap'] ?? '')), // Nama Lengkap
                        DataCell(Text(item['jenis_kelamin'] ?? '')), // Jenis Kelamin
                        DataCell(Text(item['tempat_lahir'] ?? '')), // Tempat Lahir
                        DataCell(Text(item['tgl_lahir'] ?? '')), // Tanggal Lahir
                        DataCell(Text(item['status_keluarga'] ?? '')), // Status Keluarga
                        DataCell(Text(item['status_nikah'] ?? '')), // Status Nikah
                        DataCell(Text(item['pekerjaan'] ?? '')), // Pekerjaan
                        DataCell(Text(item['status_hidup'] ?? '')), // Status Hidup
                        DataCell(Text(item['usia']?.toString() ?? '')), // Usia
                        DataCell(Text(item['tunjangan'] ?? '')), // Tunjangan
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
