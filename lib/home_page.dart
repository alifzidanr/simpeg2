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
  late Future<List<int>> statusCounts;

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
        _buildResponsiveCardLayout(isLandscape),
        _buildPieChart(),
        SizedBox(height: 20),
        _buildBarChart(),
      ],
    ),
  ),
),

    );
  }

Widget _buildResponsiveCardLayout(bool isLandscape) {
  return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = isLandscape ? 4 : 2; // 1x4 in landscape, 2x2 in portrait

      // Reduce the card size by 20px
      double cardSize = (constraints.maxWidth / crossAxisCount) - 16 - 20; // Subtract 20px for reduction

      return GridView.builder(
        physics: NeverScrollableScrollPhysics(), // Prevent scrolling within the grid
        shrinkWrap: true, // Wrap content within available space
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95, // Maintain aspect ratio, adjust for height
        ),
        itemCount: 4, // Total number of cards
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _buildStatCard('Aktif', Icons.person, Colors.green, aktifCount, cardSize);
            case 1:
              return _buildStatCard('Keluar', Icons.logout, Colors.red, keluarCount, cardSize);
            case 2:
              return _buildStatCard('Pensiun', Icons.calendar_today, Colors.orange, pensiunCount, cardSize);
            case 3:
              return _buildStatCard('Meninggal', Icons.heart_broken, Colors.grey, meninggalCount, cardSize);
            default:
              return Container(); // Safety fallback
          }
        },
      );
    },
  );
}

Widget _buildStatCard(String label, IconData icon, Color color, Future<int> countFuture, double size) {
  return FutureBuilder<int>(
    future: countFuture,
    builder: (context, snapshot) {
      String value = snapshot.hasData ? snapshot.data.toString() : '0';

      return Column(
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Container(
              width: size,
              height: size * 0.9, // Keep the height proportional to the reduced size
              padding: const EdgeInsets.all(4.0), // Keep minimal padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Use Flexible to ensure icon and text fit within the available space
                  Flexible(
                    child: Icon(
                      icon,
                      size: 30, // Adjust this size as needed
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4), // Keep small spacing to avoid overflow
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          // Label text should not overflow
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
