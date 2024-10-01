import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
class ClassPage extends StatelessWidget {
  final String idPegawai; // Add idPegawai as a parameter
  
  ClassPage({required this.idPegawai});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Golongan'),
      drawer: buildDrawer(context, idPegawai),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getGolonganData(idPegawai), // Fetch your golongan data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          final golonganData = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 100, // Set the desired height for each row
              columns: const [
                DataColumn(label: Text('File')),
                DataColumn(label: Text('No. SK')),
                DataColumn(label: Text('Perihal')),
                DataColumn(label: Text('Tanggal SK')),
                DataColumn(label: Text('Tanggal Berlaku')),
                DataColumn(label: Text('Tanggal Habis')),
                DataColumn(label: Text('Golongan')),
                DataColumn(label: Text('Pangkat')),
                DataColumn(label: Text('Aktif')),
              ],
              rows: golonganData.map<DataRow>((data) {
                return DataRow(cells: [
                  DataCell(
                    getFileCell(data['file_golongan'] ?? '') // Add image display logic here
                  ),
                  DataCell(Text(data['no_sk'] ?? 'N/A')),
                  DataCell(Text(data['hal'] ?? 'N/A')),
                  DataCell(Text(data['tgl_sk'] ?? 'N/A')),
                  DataCell(Text(data['tgl_berlaku'] ?? 'N/A')),
                  DataCell(Text(data['tgl_habis'] ?? 'N/A')),
                  DataCell(Text(data['golongan'] ?? 'N/A')),
                  DataCell(Text(data['pangkat'] ?? 'N/A')),
                  DataCell(Text(data['status_aktif'] ?? 'N/A')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
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
