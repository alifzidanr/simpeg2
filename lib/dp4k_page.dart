import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class DP4KPage extends StatefulWidget {
  final String idPegawai;

  DP4KPage({required this.idPegawai});

  @override
  _DP4KPageState createState() => _DP4KPageState();
}

class _DP4KPageState extends State<DP4KPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, int> _nilai = {};
  final int maxScore = 235;

  @override
  void initState() {
    super.initState();
    _initializeDefaultValues();
  }

  void _initializeDefaultValues() {
    final aspekList = [
      'Komitmen Organisasi',
      'Prestasi Kerja',
      'Tanggung Jawab',
      'Kerjasama',
      'Prakarsa',
      'Kepemimpinan',
      'Disiplin',
      'Kecakapan'
    ];
    for (var aspek in aspekList) {
      for (int i = 0; i < 6; i++) {
        _nilai['$aspek-$i'] = 3;
      }
    }
  }

  int _calculateTotalScore() {
    return _nilai.values.fold(0, (sum, item) => sum + item);
  }

  double _calculatePercentage() {
    return (_calculateTotalScore() / maxScore) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'DP4K Form', widget.idPegawai),
      drawer: buildDrawer(context, widget.idPegawai),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DP4K Evaluation for Employee: ${widget.idPegawai}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildAccordion(),
            SizedBox(height: 24),
            Text(
              'Total Score: ${_calculateTotalScore()} / $maxScore',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Final Percentage: ${_calculatePercentage().toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion() {
  final aspekPenilaian = {
    'Komitmen Organisasi': 6,
    'Prestasi Kerja': 6,
    'Tanggung Jawab': 6,
    'Kerjasama': 6,
    'Prakarsa': 6,
    'Kepemimpinan': 6,
    'Disiplin': 6,
    'Kecakapan': 5,
  };

  List<AccordionSection> sections = [];
  aspekPenilaian.forEach((aspek, jumlahSubAspek) {
    List<Widget> subAspekWidgets = [];
    for (int i = 0; i < jumlahSubAspek; i++) {
      subAspekWidgets.add(_buildTableRow('$aspek - Sub Aspek ${i + 1}', i));
    }
    sections.add(
      AccordionSection(
        isOpen: sections.isEmpty, // Only the first section is open by default
        header: Text(
          '$aspek',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
        content: Column(children: subAspekWidgets),
      ),
    );
  });

  return Accordion(
    maxOpenSections: 1,
    headerBackgroundColorOpened: Colors.blue,
    contentBackgroundColor: Colors.white,
    contentBorderColor: Colors.grey,
    contentHorizontalPadding: 10,
    paddingListBottom: 10,
    headerPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    children: sections,
  );
}


  Widget _buildTableRow(String aspek, int subIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('$aspek', style: TextStyle(fontSize: 16)),
          ),
          if (subIndex != -1)
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  _showRatingDialog(aspek, subIndex);
                },
                child: Text('Nilai (${_nilai['$aspek-$subIndex']})'),
              ),
            ),
        ],
      ),
    );
  }

  void _showRatingDialog(String aspek, int subIndex) {
    showDialog(
      context: context,
      builder: (context) {
        int currentValue = _nilai['$aspek-$subIndex'] ?? 3;
        return AlertDialog(
          title: Text('Set Nilai for $aspek - Sub Aspek ${subIndex + 1}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return RadioListTile<int>(
                title: Text('Nilai ${index + 1}'),
                value: index + 1,
                groupValue: currentValue,
                onChanged: (value) {
                  setState(() {
                    _nilai['$aspek-$subIndex'] = value ?? 3;
                  });
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}