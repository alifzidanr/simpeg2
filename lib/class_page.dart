import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'database_helper.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class ClassPage extends StatelessWidget {
  final String idPegawai;

  ClassPage({required this.idPegawai});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Golongan', idPegawai),
      drawer: buildDrawer(context, idPegawai),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getGolonganData(idPegawai),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF0053C5)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data yang tersedia.'));
          }

          final golonganData = snapshot.data!;

          return Row(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      child: Center(child: Text('No.', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    ...List.generate(golonganData.length, (index) {
                      return Container(
                        width: 50,
                        height: 100,
                        child: Center(child: Text('${index + 1}')),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 100,
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
                        DataCell(getFileCell(data['file_golongan'] ?? '')),
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
                ),
              ),
            ],
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
      final bytes = base64Decode(base64String);

      return Row(
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(base64String),
            child: Image.memory(
              bytes,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
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
      return Text('Error loading image');
    }
  }

  Future<void> _downloadFile(String base64String) async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(
                'Izin penyimpanan ditolak',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final bytes = base64Decode(base64String);
      final directory = Directory('/storage/emulated/0/Pictures/Al-Azhar');

      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/File_Golongan_${DateTime.now().millisecondsSinceEpoch}.png';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('File downloaded to: $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  void _showFullScreenImage(String base64String) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) {
        final bytes = base64Decode(base64String);
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final TransformationController _transformationController = TransformationController();

        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {
                // Reset to original zoom level on double-tap
                _transformationController.value = Matrix4.identity();
              },
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: isLandscape ? EdgeInsets.zero : const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: isLandscape ? BorderRadius.zero : BorderRadius.circular(12.0),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
           Positioned(
  top: 32,
  right: 16,
  child: GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    ),
  ),
),

          ],
        );
      },
    );
  }
}
