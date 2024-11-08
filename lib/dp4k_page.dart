import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'package:intl/intl.dart'; // For date formatting

class DP4KPage extends StatefulWidget {
  final String idPegawai;

  DP4KPage({required this.idPegawai});

  @override
  _DP4KPageState createState() => _DP4KPageState();
}

class _DP4KPageState extends State<DP4KPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, Map<String, int>> _monthlyScores = {};
  final int maxScore = 235;
  DateTime _selectedDate = DateTime.now();
  int _selectedDropdownValue = 0; // Default value set to 0

  final Map<String, List<String>> aspekPenilaian = {
    'Komitmen Organisasi': [
      'Mentaati semua ketentuan Lembaga/Yayasan',
      'Melaksanakan tugas/pekerjaan sesuai yang ditentukan',
      'Mendahulukan kepentingan Lembaga/Yayasan',
      'Mengindahkan larangan Lembaga/Yayasan',
      'Peka terhadap hal-hal yang dapat mengganggu Yayasan',
      'Peduli terhadap permasalahan Lembaga/Yayasan/Kantor',
    ],
    'Prestasi Kerja': [
      'Kualitas hasil pekerjaan melampaui standard',
      'Melaksanakan tugas/pekerjaan sesuai prosedur',
      'Seluruh pekerjaan yang diprogramkan diselesaikan sesuai rencana',
      'Tidak ada keluhan atas hasil dan pekerjaan yang dilakukan',
      'Berhasil mengerjakan pekerjaan di luar yang diprogram',
      'Capaian pekerjaan melampaui yang ditargetkan',
    ],
    'Tanggung Jawab': [
      'Tuntas dalam melaksanakan tugas/pekerjaan',
      'Sungguh-sungguh / serius dalam melaksanakan tugas',
      'Ramah dan santun dalam melayani kepentingan orang lain',
      'Teliti dan rapi dalam melaksanakan tugas / pekerjaan',
      'Siap menerima kompalain/keluhan atas pekerjaannya',
      'Siap menanggung resiko atas hasil dan pekerjaan yang dilakukan',
    ],
    'Kerjasama': [
      'Siap menerima kritik dan saran dari teman kerja',
      'Memberikan kritik dan saran kepada teman kerja',
      'Membantu teman yang mengalami kesulitan kerja',
      'Berbagi pengalaman dan keterampilan dengan teman kerja',
      'Tidak memaksakan kehendak kepada yang lain',
      'Koordinasi dan interaksi dengan teman dalam bekerja',
    ],
    'Prakarsa': [
      'Tidak menunggu perintah dalam pelaksanaan tugas/pekerjaan',
      'Menawarkan ide-ide baru terkait dengan tugas dan pekerjaannya',
      'Memulai pekerjaan lebih awal dari yang ditentukan',
      'Mandiri dalam melaksanakan tugas/pekerjaan',
      'Kreatif dalam melaksanakan tugas/pekerjaan',
      'Mencari cara kerja baru yang lebih efektif dan praktis',
    ],
    'Kepemimpinan': [
      'Memahami terhadap tugas dan tanggung jawabnya',
      'Membuat dan melaksanakan prioritas kerja',
      'Mempengaruhi yang lain untuk melaksanakan pekerjaanya',
      'Mengambil keputusan terbaik untuk tugas dan pekerjaanya',
      'Patuh/taat dalam melaksanakan putusan rapat',
      'Siap menerima perintah dan teguran pimpinan',
    ],
    'Disiplin': [
      'Tepat waktu melaksanakan/menyelesaikan pekerjaan',
      'Disiplin dalam melaksanakan tugas/pekerjaan',
      'Disiplin dalam menggunakan fasilitas kantor/lembaga',
      'Siap dan tepat waktu melaksanakan tugas',
      'Tepat waktu meninggalkan tempat tugas',
      'Tepat waktu hadir di tempat tugas',
    ],
    'Kecakapan': [
      'Cepat menangkap dan memahami perintah kerja',
      'Efektif dalam memanfaatkan waktu kerja',
      'Efisien dalam penggunaan sumber daya',
      'Berhasil menyelesaikan tugas/pekerjaan sesuai yang direncanakan',
      'Menyelesaikan permasalahan pekerjaan di luar prosedur baku',
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeDefaultValues();
    _loadScores(); // Load the scores when the page is first opened
  }

  void _initializeDefaultValues() {
    String monthYearKey = _formatMonthYear(_selectedDate);
    if (!_monthlyScores.containsKey(monthYearKey)) {
      _monthlyScores[monthYearKey] = {};
      for (var aspekEntry in aspekPenilaian.entries) {
        String aspek = aspekEntry.key;
        List<String> subAspekList = aspekEntry.value;
        int defaultValue = ([
          'Komitmen Organisasi',
          'Prestasi Kerja',
          'Tanggung Jawab',
          'Kerjasama'
        ].contains(aspek))
            ? 3
            : 2;
        for (int i = 0; i < subAspekList.length; i++) {
          _monthlyScores[monthYearKey]!['$aspek-$i'] = defaultValue;
        }
      }
    }
  }

  Future<void> _saveScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String monthYearKey = _formatMonthYear(_selectedDate);

    int totalScore = _calculateTotalScore();
    double percentage = _calculatePercentage();

    await prefs.setInt('${monthYearKey}_totalScore', totalScore);
    await prefs.setDouble('${monthYearKey}_percentage', percentage);
    // Save individual scores as well
    _monthlyScores[monthYearKey]!.forEach((key, value) async {
      await prefs.setInt('${monthYearKey}_$key', value);
    });
  }

  Future<void> _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String monthYearKey = _formatMonthYear(_selectedDate);

    // Load individual scores
    for (var aspekEntry in aspekPenilaian.entries) {
      String aspek = aspekEntry.key;
      List<String> subAspekList = aspekEntry.value;
      for (int i = 0; i < subAspekList.length; i++) {
        String key = '$aspek-$i';
        int? score = prefs.getInt('${monthYearKey}_$key');
        if (score != null) {
          _monthlyScores[monthYearKey]![key] = score;
        }
      }
    }

    // Load total score and percentage
    setState(() {
      // This is needed to refresh the UI with the loaded scores
    });
  }

  String _formatMonthYear(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  void _setAllValues(int value) {
    String monthYearKey = _formatMonthYear(_selectedDate);
    setState(() {
      _monthlyScores[monthYearKey]!.updateAll((key, oldValue) => value);
    });
    _saveScores(); // Save the scores after setting all values
  }

  int _calculateTotalScore() {
    String monthYearKey = _formatMonthYear(_selectedDate);
    Map<String, int>? scores = _monthlyScores[monthYearKey];
    if (scores == null) return 0;

    return scores.values.fold<int>(
      0,
      (int sum, int? item) => sum + (item ?? 0),
    );
  }

  double _calculatePercentage() {
    return (_calculateTotalScore() / maxScore) * 100;
  }

  Future<void> _pickMonthYear(BuildContext context) async {
    DateTime initialDate = DateTime(_selectedDate.year, _selectedDate.month);
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Month and Year',
      fieldLabelText: 'Month/Year',
      fieldHintText: 'Month/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month);
        _selectedDropdownValue = 0; // Reset the dropdown to 0
        _initializeDefaultValues();
        _loadScores(); // Load scores for the newly selected month
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String monthYearDisplay = DateFormat('MMMM yyyy').format(_selectedDate);
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Form DP4K', widget.idPegawai),
      drawer: buildDrawer(context, widget.idPegawai),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickMonthYear(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Period',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(text: monthYearDisplay),
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Text(
            //   'DP4K Evaluation for Employee: ${widget.idPegawai}',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Atur semua aspek:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedDropdownValue,
                  items: List.generate(6, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text('$index'),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDropdownValue = value;
                        _setAllValues(value);
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildAccordion(),
            SizedBox(height: 8),
Card(
  elevation: 4,
  margin: EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.grade, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text(
              'Nilai Total',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              '${_calculateTotalScore()} / $maxScore',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.percent, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text(
              'Persentase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              '${_calculatePercentage().toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
        SizedBox(height: 16),
        LinearProgressIndicator(
          value: _calculatePercentage() / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          minHeight: 8,
        ),
      ],
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  Widget _buildAccordion() {
    String monthYearKey = _formatMonthYear(_selectedDate);
    Map<String, int> currentScores = _monthlyScores[monthYearKey]!;

    return Column(
      children: aspekPenilaian.entries.map((entry) {
        String aspek = entry.key;
        List<String> subAspekList = entry.value;

        List<Widget> subAspekWidgets = [];
        for (int i = 0; i < subAspekList.length; i++) {
          String subAspekName = subAspekList[i];
          subAspekWidgets.add(_buildTableRow(aspek, subAspekName, i, currentScores));
        }

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                '$aspek',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
              children: subAspekWidgets,
              iconColor: Colors.blue,
              collapsedIconColor: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTableRow(String aspek, String subAspekName, int subIndex, Map<String, int> currentScores) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('$subAspekName', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                _showRatingDialog(aspek, subIndex);
              },
              child: Text('Nilai (${currentScores["$aspek-$subIndex"]})'),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(String aspek, int subIndex) {
    String monthYearKey = _formatMonthYear(_selectedDate);
    Map<String, int> currentScores = _monthlyScores[monthYearKey]!;
    String subAspekName = aspekPenilaian[aspek]?[subIndex] ?? 'Sub Aspek ${subIndex + 1}';

    showDialog(
      context: context,
      builder: (context) {
        int currentValue = currentScores['$aspek-$subIndex'] ??
            ([
              'Komitmen Organisasi',
              'Prestasi Kerja',
              'Tanggung Jawab',
              'Kerjasama'
            ].contains(aspek)
                ? 3
                : 2);

        return AlertDialog(
          title: Text('Set Nilai for $aspek - $subAspekName'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(6, (index) {
                return RadioListTile<int>(
                  title: Text('$index'),
                  value: index,
                  groupValue: currentValue,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentScores['$aspek-$subIndex'] = value;
                      });
                      Navigator.of(context).pop();
                      _saveScores(); // Save scores after modifying individual aspects
                    }
                  },
                );
              }),
            ),
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