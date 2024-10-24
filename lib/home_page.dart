import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  final String idPegawai;

  HomePage({required this.idPegawai});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<int> aktifCount;
  late Future<int> keluarCount;
  late Future<int> pensiunCount;
  late Future<int> meninggalCount;
  late Future<List<int>> statusCounts; // For the charts

  @override
  void initState() {
    super.initState();
    aktifCount = DatabaseHelper.instance.getCountByStatus(1);
    keluarCount = DatabaseHelper.instance.getCountByStatus(2);
    pensiunCount = DatabaseHelper.instance.getCountByStatus(3);
    meninggalCount = DatabaseHelper.instance.getCountByStatus(4);
    statusCounts = DatabaseHelper.instance.getStatusCounts();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Dashboard', widget.idPegawai),
      drawer: buildDrawer(context, widget.idPegawai),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              isLandscape ? _buildCardRow() : _buildCardGrid(),
              _buildPieChart(),
              SizedBox(height: 20),
              _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  // Build a Row for landscape mode without scrolling
  Widget _buildCardRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth / 4) - 16;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard('Aktif', Icons.person, Colors.green, aktifCount, cardWidth),
            _buildStatCard('Keluar', Icons.logout, Colors.red, keluarCount, cardWidth),
            _buildStatCard('Pensiun', Icons.calendar_today, Colors.orange, pensiunCount, cardWidth),
            _buildStatCard('Meninggal', Icons.heart_broken, Colors.grey, meninggalCount, cardWidth),
          ],
        );
      },
    );
  }

  // Build a Grid for portrait mode
  Widget _buildCardGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth / 2 - 24;
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: cardWidth / (cardWidth * 0.75),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard('Aktif', Icons.person, Colors.green, aktifCount, cardWidth),
            _buildStatCard('Keluar', Icons.logout, Colors.red, keluarCount, cardWidth),
            _buildStatCard('Pensiun', Icons.calendar_today, Colors.orange, pensiunCount, cardWidth),
            _buildStatCard('Meninggal', Icons.heart_broken, Colors.grey, meninggalCount, cardWidth),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, IconData icon, Color color, Future<int> countFuture, double width) {
    return FutureBuilder<int>(
      future: countFuture,
      builder: (context, snapshot) {
        String value = snapshot.hasData ? snapshot.data.toString() : '0';

        return Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: width,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 30,
                      color: color,
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPieChart() {
    return FutureBuilder<List<int>>(
      future: statusCounts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0053C5),
            ),
          );
        }

        List<int> counts = snapshot.data!;
        List<String> labels = ['GTYK', 'GTY', 'TUY', 'TUYK', 'KTY'];

        // Calculate total count to compute percentages
        int total = counts.reduce((a, b) => a + b);
        List<double> percentages = counts.map((count) => (count / total) * 100).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: List.generate(
                      counts.length,
                      (index) => PieChartSectionData(
                        value: counts[index].toDouble(),
                        title: '${percentages[index].toStringAsFixed(1)}%',
                        color: Colors.primaries[index % Colors.primaries.length],
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40,
                    sectionsSpace: 0,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildLegend(labels),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(List<String> labels) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: List.generate(labels.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              color: Colors.primaries[index % Colors.primaries.length],
            ),
            SizedBox(width: 4),
            Text(
              labels[index],
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBarChart() {
    return FutureBuilder<List<int>>(
      future: statusCounts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0053C5),
            ),
          );
        }

        List<int> counts = snapshot.data!;
        List<String> labels = ['GTYK', 'GTY', 'TUY', 'TUYK', 'KTY'];

        return Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 20.0),
          child: SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, index, rod, to) {
                      String label = labels[group.x.toInt()];
                      return BarTooltipItem(
                        '$label\n${rod.toY}',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            labels[value.toInt()],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                barGroups: List.generate(
                  counts.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: counts[index].toDouble(),
                        color: Colors.blue,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                maxY: (counts.reduce((a, b) => a > b ? a : b)).toDouble() + 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
