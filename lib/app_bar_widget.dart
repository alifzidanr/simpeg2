import 'package:flutter/material.dart';

AppBar buildAppBar(GlobalKey<ScaffoldState> scaffoldKey, String title) {
  return AppBar(
    backgroundColor: Color(0xFF0053C5),
    leading: IconButton(
      icon: Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.account_circle, color: Colors.white),
        onPressed: () {},
      ),
    ],
  );
}
