import 'package:flutter/material.dart';
import 'app_bar_widget.dart'; // Import the reusable AppBar widget
import 'drawer_widget.dart';

class ClassPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Golongan'), // Use reusable AppBar
      drawer: buildDrawer(context), // Add your drawer if needed
      body: Center(child: Text('Riwayat Golongan Page')),
    );
  }
}
