import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper
import 'drawer_widget.dart'; // Import your drawer widget
import 'app_bar_widget.dart'; // Import your app bar widget
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

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
      // Upload the image or update the profile with the new image
      print('Image selected: ${pickedFile.path}');
      // Here you can add the logic to upload the image and update the profileData
    }
  }

  void _deletePhoto() {
    // Implement logic to delete the photo from the database
    print('Photo deleted');
    setState(() {
      profileData!['url_foto'] = null; // Update the profileData to reflect the change
    });
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
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _showImageOptions, // Show options on tap
                        child: _buildProfileImage(),
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

  // Method to create the profile image widget
  Widget _buildProfileImage() {
    String? imageUrl = profileData?['url_foto'];
    return Center(
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(Icons.account_circle, size: 100) // Fallback icon if no image
          : ClipOval(
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 100); // Error icon
                },
              ),
            ),
    );
  }

  // Method to format Unit Kerja (you can modify the logic as needed)
  String _formatUnitKerja(String unitKerja) {
    return unitKerja.isEmpty ? 'N/A' : unitKerja;
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
