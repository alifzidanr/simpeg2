import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';

class EducationPage extends StatefulWidget {
  final String idPegawai;

  EducationPage({required this.idPegawai});

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  late Future<List<Map<String, dynamic>>> _educationData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _educationData = DatabaseHelper.instance.getEducationData(widget.idPegawai);
  }

  // Function to format date from 'yyyy-mm-dd' to 'dd-mm-yy'
  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Pendidikan', widget.idPegawai),
      drawer: buildDrawer(context, widget.idPegawai),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _educationData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF0053C5),));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data yang tersedia.'));
          }

          final educationList = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Fixed column for 'Jenjang' with shorter width
                  Container(
                    width: 80, // Shorter width
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Jenjang')),
                      ],
                      rows: educationList.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['Jenjang'] ?? '')),
                        ]);
                      }).toList(),
                    ),
                  ),
                  // Scrollable columns
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Gelar')),
                          DataColumn(label: Text('Prodi')),
                          DataColumn(label: Text('Institusi')),
                          DataColumn(label: Text('Kota')),
                          DataColumn(label: Text('Negara')),
                          DataColumn(label: Text('Tanggal Ijazah')),
                          DataColumn(label: Text('Akreditasi')),
                        ],
                        rows: educationList.map((data) {
                          return DataRow(cells: [
                            DataCell(Text(data['Gelar'] ?? '')),
                            DataCell(Text(data['Prodi'] ?? '')),
                            DataCell(Text(data['Institusi'] ?? '')),
                            DataCell(Text(data['Kota'] ?? '')),
                            DataCell(Text(data['Negara'] ?? '')),
                            DataCell(Text(formatDate(data['Tanggal_Ijazah'] ?? ''))),
                            DataCell(Text(data['Akreditasi'] ?? '')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
