import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class CareerPage extends StatelessWidget {
  final String idPegawai; // Add idPegawai as a parameter
  
  CareerPage({required this.idPegawai});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Jabatan', idPegawai), // Pass idPegawai here
      drawer: buildDrawer(context, idPegawai),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getCareerData(idPegawai), // Fetch your career data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF0053C5),));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data yang tersedia.'));
          }

          final careerData = snapshot.data!;

          return Row(
            children: [
              // Fixed "No." column
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50, // Width for the fixed "No." header
                      child: Center(child: Text('No.', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    ...List.generate(careerData.length, (index) {
                      return Container(
                        width: 50, // Width for each row in the "No." column
                        height: 100, // Match the row height of the main table
                        child: Center(child: Text('${index + 1}')),
                      );
                    }),
                  ],
                ),
              ),
              // Scrollable table for other columns
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                  child: DataTable(
                    dataRowHeight: 100, // Set the desired height for each row
                    columns: [
                      DataColumn(label: Text('File')),
                      DataColumn(label: Text('No. SK')),
                      DataColumn(label: Text('Perihal')),
                      DataColumn(label: Text('Tanggal SK')),
                      DataColumn(label: Text('Tanggal Berlaku')),
                      DataColumn(label: Text('Tanggal Berakhir')),
                      DataColumn(label: Text('Jabatan')),
                      DataColumn(label: Text('Unit Kerja')),
                      DataColumn(label: Text('Aktif')),
                    ],
                    rows: careerData.map<DataRow>((career) {
                      return DataRow(cells: [
                        DataCell(getFileCell(career['file_jabatan'] ?? '')),
                        DataCell(Text(career['no_sk'] ?? '')),
                        DataCell(Text(career['hal'] ?? '')),
                        DataCell(Text(career['tgl_sk'] ?? '')),
                        DataCell(Text(career['tgl_berlaku'] ?? '')),
                        DataCell(Text(career['tgl_sd'] ?? '')),
                        DataCell(Text(career['jabatan'] ?? '')),
                        DataCell(Text(formatUnitKerja(career['unit_kerja'] ?? ''))),
                        DataCell(Text(career['status_aktif'] ?? '')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to format unit kerja
  String formatUnitKerja(String unitKerja) {
    // Remove "40-" and "TRIAL" from the string
    return unitKerja.replaceAll(RegExp(r'^\d+-|TRIAL-', caseSensitive: false), '').trim();
  }

  Widget getFileCell(String base64String) {
    if (base64String.isEmpty) {
      return Text('No file');
    }

    try {
      // Decode the base64 string
      final bytes = base64Decode(base64String);
      
      return Row(
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(base64String), // Show full screen image on tap
            child: Image.memory(
              bytes, // Use Image.memory to display the image
              width: 50, // Set your desired width
              height: 50, // Set your desired height
              fit: BoxFit.cover, // Fit the image in the box
            ),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _downloadFile(base64String);
            },
          ),
        ],
      );
    } catch (e) {
      return Text('Error loading image'); // Display error if decoding fails
    }
  }

 Future<void> _downloadFile(String base64String) async {
  try {
    // Request manage storage permission for Android 13+
    if (await Permission.manageExternalStorage.request().isGranted) {
      final bytes = base64Decode(base64String);
      String downloadsPath = '/storage/emulated/0/Pictures';
      String fileName = 'File_Jabatan_${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = '$downloadsPath/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('File downloaded to: $filePath')),
      );
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(content: Text('Error downloading file: $e')),
    );
  }
}

  // Function to show the full screen image
  void _showFullScreenImage(String base64String) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) {
        // Decode the base64 string for full-screen display
        final bytes = base64Decode(base64String);
        
        return Dialog(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
