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
    appBar: buildAppBar(_scaffoldKey, 'Profile Pegawai'),
    drawer: buildDrawer(context, widget.idPegawai),
    body: profileData == null
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0), // Add 15px top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReadOnlyTextField(label: 'Nama Lengkap', value: profileData!['nama_lengkap']),
                    SizedBox(height: 16), // Add vertical space
                    _buildReadOnlyTextField(label: 'NIP', value: profileData!['nip']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Jabatan Pegawai', value: profileData!['jabatan_pegawai']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Unit Kerja', value: _formatUnitKerja(profileData!['unit_kerja'] ?? 'N/A')),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Status Pegawai', value: profileData!['status_pegawai']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Gelar Depan', value: profileData!['gelar_depan']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Gelar Belakang', value: profileData!['gelar_belakang']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Bidang Diampu', value: profileData!['bidang_diampu']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Tempat, Tanggal Lahir', value: '${profileData!['tempat_lahir'] ?? 'N/A'}, ${profileData!['tgl_lahir'] ?? 'N/A'}'),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'KTP', value: profileData!['no_ktp']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'NPWP', value: profileData!['npwp']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Jenis Kelamin', value: profileData!['jenis_kelamin']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Status Menikah', value: profileData!['status_nikah']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Golongan Darah', value: profileData!['golongan_darah']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Regional', value: profileData!['regional']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Alamat', value: profileData!['alamat']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Kota', value: profileData!['kota']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Provinsi', value: profileData!['propinsi']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Kode Pos', value: profileData!['kode_pos']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'No. Telepon', value: profileData!['no_telepon']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'No. Handphone', value: profileData!['no_hp']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Email', value: profileData!['email']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Ayah Kandung', value: profileData!['ayah_kandung']),
                    SizedBox(height: 16),
                    _buildReadOnlyTextField(label: 'Ibu Kandung', value: profileData!['ibu_kandung']),
                  ],
                ),
              ),
            ),
          ),
  );
}

  // Method to format the unit kerja string
  String _formatUnitKerja(String unitKerja) {
    // Split the string based on the separator, e.g., '-'
    var parts = unitKerja.split('-');
    if (parts.length > 1) {
      return parts[1].trim(); // Return the middle part (desired unit name)
    }
    return unitKerja; // Return the original string if the format is unexpected
  }

 
  // Helper method to create read-only text fields with floating labels
Widget _buildReadOnlyTextField({required String label, String? value}) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    readOnly: true,
    controller: TextEditingController(text: value ?? 'N/A'), // Fallback to 'N/A' if value is null
  );
}

}

