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
              // Fixed "No." column with correct height adjustment
              SingleChildScrollView(
                child: Table(
                  columnWidths: const {0: FixedColumnWidth(50)}, // Fixed width for the "No." column
                  children: [
                    TableRow(
                      children: [
                        Container(
                          height: 56, // Same height as the header row of DataTable
                          child: Center(
                            child: Text('No.', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(careerData.length, (index) {
                      return TableRow(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).orientation == Orientation.landscape
                                ? MediaQuery.of(context).size.height * 0.15
                                : MediaQuery.of(context).size.height * 0.1, // Match the row height of DataTable
                            child: Center(child: Text('${index + 1}')),
                          ),
                        ],
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
                    dataRowHeight: MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height * 0.1, // Match the row height of the "No." column
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
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      // Decode the base64 string to bytes
      final bytes = base64Decode(base64String);

      // Define the path to the Downloads folder
      String downloadsPath = '/storage/emulated/0/Pictures';

      // Generate a unique file name using the current timestamp
      String fileName = 'downloaded_image_${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = '$downloadsPath/$fileName';

      // Write the file
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Show a snackbar or dialog to confirm the download
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('File downloaded to: $filePath')),
      );
    } catch (e) {
      // Handle errors if the download fails
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
