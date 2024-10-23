import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

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
    appBar: buildAppBar(_scaffoldKey, 'Data Keluarga', idPegawai),
    drawer: buildDrawer(context, idPegawai),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchFamilyData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF0053C5),));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada data yang tersedia.'));
        }

        List<Map<String, dynamic>> familyData = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed 'Nama Lengkap' column
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowHeight: 70,
                  columns: [
                    DataColumn(
                      label: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Nama', style: TextStyle(fontSize: 14)),
                            Text('Lengkap', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  rows: List.generate(familyData.length, (index) {
                    final item = familyData[index];
                    return DataRow(
                      cells: [
                        DataCell(Text(item['nama_lengkap'] ?? '')), // Nama Lengkap
                      ],
                    );
                  }),
                ),
              ),
              // Scrollable part for other columns
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 18,
                    headingRowHeight: 70,
                    columns: [
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Jenis', style: TextStyle(fontSize: 14)),
                              Text('Kelamin', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tempat', style: TextStyle(fontSize: 14)),
                              Text('Lahir', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tanggal', style: TextStyle(fontSize: 14)),
                              Text('Lahir', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Status', style: TextStyle(fontSize: 14)),
                              Text('Keluarga', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Status', style: TextStyle(fontSize: 14)),
                              Text('Nikah', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Pekerjaan', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Status', style: TextStyle(fontSize: 14)),
                              Text('Hidup', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Usia', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tunjangan', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(familyData.length, (index) {
                      final item = familyData[index];
                      return DataRow(
                        cells: [
                          DataCell(Text(item['jenis_kelamin'] ?? '')), // Jenis Kelamin
                          DataCell(Text(item['tempat_lahir'] ?? '')), // Tempat Lahir
                          DataCell(Text(_formatDate(item['tgl_lahir']))), // Tanggal Lahir
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
            ],
          ),
        );
      },
    ),
  );
}

  // Function to format the date
  String _formatDate(String? date) {
    if (date == null) return '';
    DateTime parsedDate = DateTime.parse(date); // Assuming the date is in ISO format
    return DateFormat('dd-MM-yy').format(parsedDate); // Format to dd-mm-yy
  }
}
