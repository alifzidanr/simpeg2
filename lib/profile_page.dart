import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper
import 'drawer_widget.dart'; // Import your drawer widget
import 'app_bar_widget.dart'; // Import your app bar widget

class ProfilePage extends StatefulWidget {
  final String idPegawai; // Pass the idPegawai to the ProfilePage

  ProfilePage({required this.idPegawai});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      print('Fetching profile for ID Pegawai: ${widget.idPegawai}');
      profileData = await DatabaseHelper().getEmployeeProfile(widget.idPegawai);

      // Log the profile data
      print('Profile data: $profileData');

      setState(() {}); // Update the UI
    } catch (e) {
      print('Error fetching profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Profile Pegawai'), // Use your custom app bar
      drawer: buildDrawer(context, widget.idPegawai), // Use the existing drawer
      body: profileData == null
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildReadOnlyTextField(
                      label: 'Nama Lengkap', value: profileData!['nama_lengkap']),
                  SizedBox(height: 16),
                  _buildReadOnlyTextField(
                      label: 'NIP', value: profileData!['nip']),
                  SizedBox(height: 16),
                  _buildReadOnlyTextField(
                      label: 'Jabatan Pegawai',
                      value: profileData!['id_ref_jabatan_pegawai'].toString()),
                  SizedBox(height: 16),
                  _buildReadOnlyTextField(
                      label: 'Unit Kerja',
                      value: profileData!['id_unit_kerja'].toString()),
                ],
              ),
            ),
    );
  }

  // Helper method to create read-only text fields with floating labels
  Widget _buildReadOnlyTextField({required String label, required String value}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      controller: TextEditingController(text: value),
    );
  }
}
