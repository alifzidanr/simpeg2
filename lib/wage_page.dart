import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class WagePage extends StatelessWidget {
   final String idPegawai; // Add idPegawai as a parameter
  
  WagePage({required this.idPegawai});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Slip Gaji', idPegawai),
      drawer: buildDrawer(context, idPegawai),
      body: Center(child: Text('Tidak ada data yang tersedia.')),
    );
  }
}
