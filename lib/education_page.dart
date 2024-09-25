import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class EducationPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Riwayat Pendidikan'),
      drawer: buildDrawer(context),
      body: Center(child: Text('Riwayat Pendidikan Page')),
    );
  }
}
