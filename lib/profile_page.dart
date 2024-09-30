import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper
import 'drawer_widget.dart'; // Import your drawer widget
import 'app_bar_widget.dart'; // Import your app bar widget
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // For base64 encoding/decoding
import 'package:intl/intl.dart';


class ProfilePage extends StatefulWidget {
  final String idPegawai; // Change it back to String

  const ProfilePage({Key? key, required this.idPegawai}) : super(key: key); // Ensure the constructor is consistent

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
      profileData = await DatabaseHelper.instance.getEmployeeProfile(widget.idPegawai);
      print('Profile data: $profileData');
      setState(() {}); // Update the UI
    } catch (e) {
      print('Error fetching profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data')),
      );
    }
}


  Future<void> _showImageOptions() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Profile Photo'),
          content: Text('What would you like to do?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestFilePermission();
              },
              child: Text('Change Photo'),
            ),
            TextButton(
              onPressed: () {
                // Implement the delete photo logic here
                _deletePhoto();
                Navigator.of(context).pop();
              },
              child: Text('Delete Photo'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _requestFilePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      _pickImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied!')),
      );
    }
  }

 Future<void> _pickImage() async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    try {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Now you can use DatabaseHelper.instance to update the image
      await DatabaseHelper.instance.updateEmployeePhoto(widget.idPegawai, base64Image);

      print('Image uploaded/updated: ${pickedFile.path}');

      // Show a SnackBar to inform the user that the image was uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );

      // Refresh the profile data
      await _fetchProfileData();  // Call to fetch updated data
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image!')),
      );
    }
  } else {
    print('No image selected.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No image selected.')),
    );
  }
}


void _deletePhoto() async {
  await DatabaseHelper.instance.deleteEmployeePhoto(widget.idPegawai); // Delete photo from database

  // Fetch the updated profile data after deletion
  await _fetchProfileData(); // Call to fetch updated data

  // Show confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Photo deleted successfully!')),
  );

  print('Photo deleted');
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
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Centering the profile image in the layout
                       Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0), // Adjust vertical padding as needed
                          child: GestureDetector(
                            onTap: _showImageOptions,
                            child: _buildProfileImage(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildReadOnlyTextField(label: 'Nama Lengkap', value: profileData!['nama_lengkap']),
                      SizedBox(height: 16),
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
                      _buildReadOnlyTextField(
                        label: 'Tempat, Tanggal Lahir',
                        value: '${profileData!['tempat_lahir'] ?? 'N/A'}, ${_formatDate(profileData!['tgl_lahir'])}',
                      ),
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

 Widget _buildProfileImage() {
  print('Profile image URL: ${profileData!['url_foto']}'); // Debugging line
  if (profileData != null && profileData!['url_foto'] != null) {
    if (profileData!['url_foto'].startsWith('http')) {
      // Image from a URL
      return Center(
        child: ClipOval(
          child: Image.network(
            profileData!['url_foto'],
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 120);
            },
          ),
        ),
      );
    } else {
      try {
        // Image is base64 encoded
        final decodedBytes = base64Decode(profileData!['url_foto']);
        return Center(
          child: ClipOval(
            child: Image.memory(
              decodedBytes,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        print('Error decoding base64 image: $e');
        return Center(
          child: ClipOval(
            child: Icon(Icons.error, size: 150),
          ),
        );
      }
    }
  } else {
    // Default icon
    return Center(
      child: ClipOval(
        child: Icon(Icons.account_circle, size: 150),
      ),
    );
  }
}


  // Method to format Unit Kerja (you can modify the logic as needed)
  String _formatUnitKerja(String unitKerja) {
  if (unitKerja.isEmpty) {
    return 'N/A';
  }

  // Remove 'TRIAL-' prefix
  if (unitKerja.startsWith('TRIAL-')) {
    unitKerja = unitKerja.replaceFirst('TRIAL-', '');
  }

  // Remove the numeric suffix after the last '-'
  int lastDashIndex = unitKerja.lastIndexOf('-');
  if (lastDashIndex != -1) {
    unitKerja = unitKerja.substring(0, lastDashIndex);
  }

  return unitKerja;
}

String _formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  try {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yy').format(parsedDate);
  } catch (e) {
    return 'N/A'; // Return 'N/A' if the date is invalid
  }
}

  // Method to create read-only text fields
  Widget _buildReadOnlyTextField({required String label, required String? value}) {
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
