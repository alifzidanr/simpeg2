import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class ProfilePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Profile Pegawai'),
      drawer: buildDrawer(context), // Use reusable Drawer
      body: Center(child: Text('Profile Pegawai Page')),
    );
  }
}
