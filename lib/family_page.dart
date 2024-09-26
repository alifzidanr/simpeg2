import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class FamilyPage extends StatelessWidget {
   final String idPegawai; // Add idPegawai as a parameter
  
  FamilyPage({required this.idPegawai});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Data Keluarga'),
      drawer: buildDrawer(context, idPegawai),
      body: Center(child: Text('Data Keluarga Page')),
    );
  }
}
