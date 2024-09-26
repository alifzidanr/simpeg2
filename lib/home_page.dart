import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
   final String idPegawai; // Add idPegawai as a parameter
  
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
  late Future<List<int>> statusCounts; // For the bar chart

  @override
  void initState() {
    super.initState();
    aktifCount = DatabaseHelper().getCountByStatus(1);
    keluarCount = DatabaseHelper().getCountByStatus(2);
    pensiunCount = DatabaseHelper().getCountByStatus(3);
    meninggalCount = DatabaseHelper().getCountByStatus(4);
    statusCounts = DatabaseHelper().getStatusCounts(); // Fetch status counts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Dashboard'),
       drawer: buildDrawer(context, widget.idPegawai),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(  
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2 / 1.5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('Aktif', Icons.person, Colors.green, aktifCount),
                  _buildStatCard('Keluar', Icons.logout, Colors.red, keluarCount),
                  _buildStatCard('Pensiun', Icons.calendar_today, Colors.orange, pensiunCount),
                  _buildStatCard('Meninggal', Icons.heart_broken, Colors.grey, meninggalCount),
                ],
              ),
              SizedBox(height: 20),
              _buildBarChart(), // Add the bar chart
              SizedBox(height: 20),
              _buildPieChart(), // Add the pie chart
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, IconData icon, Color color, Future<int> countFuture) {
    return FutureBuilder<int>(
      future: countFuture,
      builder: (context, snapshot) {
        String value = snapshot.hasData ? snapshot.data.toString() : '0';
        return Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 38,
                          color: color,
                        ),
                        SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 18,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }


  // Build the legend for the pie chart
Widget _buildLegend(List<String> labels) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(labels.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: Colors.primaries[index % Colors.primaries.length],
            ),
            SizedBox(width: 4),
            Text(
              labels[index],
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }),
  );
}

  // Build PieChart using fl_chart package
Widget _buildPieChart() {
  return FutureBuilder<List<int>>(
    future: statusCounts,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      List<int> counts = snapshot.data!;
      List<String> labels = ['GTYK', 'GTY', 'TUY', 'TUYK', 'KTY'];
      
      // Calculate total count to compute percentages
      int total = counts.reduce((a, b) => a + b);
      List<double> percentages = counts.map((count) => (count / total) * 100).toList();

      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
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
                      title: '${percentages[index].toStringAsFixed(1)}%', // Show percentage
                      color: Colors.primaries[index % Colors.primaries.length], // Cycle through colors
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 14,
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
            _buildLegend(labels), // Add the legend below the pie chart
          ],
        ),
      );
    },
  );
}

 // Build BarChart using fl_chart package
  Widget _buildBarChart() {
    return FutureBuilder<List<int>>(
      future: statusCounts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<int> counts = snapshot.data!;
        List<String> labels = ['GTYK', 'GTY', 'TUY', 'TUYK', 'KTY'];

        return Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 20.0), // Added right padding here
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
                              fontSize: 12,
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
                        width: 20,
                        borderRadius: BorderRadius.circular(6),
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
