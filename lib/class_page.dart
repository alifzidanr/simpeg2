import 'package:flutter/material.dart';
import 'app_bar_widget.dart'; // Import the reusable AppBar widget
import 'drawer_widget.dart';

class ClassPage extends StatelessWidget {
   final String idPegawai; // Add idPegawai as a parameter
  
  ClassPage({required this.idPegawai});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Golongan'), // Use reusable AppBar
      drawer: buildDrawer(context, idPegawai), 
      body: Center(child: Text('Riwayat Golongan Page')),
    );
  }
}
