import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'class_page.dart';
import 'career_page.dart';
import 'education_page.dart';
import 'family_page.dart';
import 'wage_page.dart';
import 'home_page.dart';

Drawer buildDrawer(BuildContext context, String idPegawai) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF0053C5)),
          padding: EdgeInsets.only(top: 20, bottom: 16),
          child: Center(
            child: Image.asset(
              'assets/Logo_YPIA.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Dashboard'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(idPegawai: idPegawai)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile Pegawai'),
          onTap: () {
            Navigator.push( 
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(idPegawai: idPegawai), // Pass idPegawai here
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.timeline),
          title: Text('Riwayat Golongan'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassPage(idPegawai: idPegawai)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.work),
          title: Text('Riwayat Jabatan'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CareerPage(idPegawai: idPegawai)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.school),
          title: Text('Riwayat Pendidikan'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducationPage(idPegawai: idPegawai)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.family_restroom),
          title: Text('Data Keluarga'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FamilyPage(idPegawai: idPegawai)),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.receipt),
          title: Text('Slip Gaji'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WagePage(idPegawai: idPegawai)),
            );
          },
        ),
      ],
    ),
  );
}
