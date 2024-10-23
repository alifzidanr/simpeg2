import 'package:flutter/material.dart';
import 'database_helper.dart'; 
import 'drawer_widget.dart'; 
import 'app_bar_widget.dart'; 
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img; 

class ProfilePage extends StatefulWidget {
  final String idPegawai;

  const ProfilePage({Key? key, required this.idPegawai}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? profileData;
  bool _isLoading = true; // Add this to track loading state

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      print('Fetching profile for ID Pegawai: ${widget.idPegawai}');
      profileData = await DatabaseHelper.instance.getEmployeeProfile(widget.idPegawai);
      print('Profile data: $profileData');
    } catch (e) {
      print('Error fetching profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data profil')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading after data is fetched
      });
    }
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _requestFilePermission();
                },
                child: Text('Ganti Foto'),
              ),
              TextButton(
                onPressed: () {
                  _deletePhoto();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Hapus Foto',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal'),
              ),
            ],
          ),
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
        SnackBar(content: Text('Izin ditolak')),
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

        await DatabaseHelper.instance.updateEmployeePhoto(widget.idPegawai, base64Image);

        print('Image uploaded/updated: ${pickedFile.path}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil diunggah!')),
        );

        await _fetchProfileData();
      } catch (e) {
        print('Error picking image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar!')),
        );
      }
    } else {
      print('No image selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada gambar yang dipilih.')),
      );
    }
  }

  void _deletePhoto() async {
    await DatabaseHelper.instance.deleteEmployeePhoto(widget.idPegawai);

    await _fetchProfileData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto berhasil dihapus!')),
    );

    print('Foto dihapus.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(_scaffoldKey, 'Profile Pegawai', widget.idPegawai),
      drawer: buildDrawer(context, widget.idPegawai),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0053C5), // Loader with specified color
              ),
            )
          : profileData == null
              ? Center(child: Text('No profile data found.'))
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Padding only for the content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      // Centering the profile image in the layout
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
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
            ]),
    );
  }

  Widget _buildProfileImage() {
  print('Profile image data: ${profileData!['url_foto']}');
  if (profileData != null && profileData!['url_foto'] != null) {
    if (profileData!['url_foto'].startsWith('http')) {
      // Image from a URL
      return Center(
        child: Container(
          width: 170, // Explicit size
          height: 170, // Explicit size
          child: ClipOval(
            child: Image.network(
              profileData!['url_foto'],
              height: 170, // Ensure this size is respected
              width: 170,  // Ensure this size is respected
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ClipOval(
                  child: Icon(Icons.account_circle, size: 170), // Increased size
                );
              },
            ),
          ),
        ),
      );
    } else {
      try {
        // Image is base64 encoded
        final decodedBytes = base64Decode(profileData!['url_foto']);

        // Validate image data using the image package
        final image = img.decodeImage(decodedBytes);
        if (image == null) {
          throw Exception('Invalid image data');
        }

        return Center(
          child: Container(
            width: 170, // Explicit size
            height: 170, // Explicit size
            child: ClipOval(
              child: Image.memory(
                decodedBytes,
                height: 170, // Ensure this size is respected
                width: 170,  // Ensure this size is respected
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      } catch (e) {
        print('Error decoding base64 image: $e');
        // Return default icon
        return Center(
          child: Container(
            width: 170, // Explicit size
            height: 170, // Explicit size
            child: ClipOval(
              child: Icon(Icons.account_circle, size: 170), // Increased size
            ),
          ),
        );
      }
    }
  } else {
    // Default icon
    return Center(
      child: Container(
        width: 170, // Explicit size
        height: 170, // Explicit size
        child: ClipOval(
          child: Icon(Icons.account_circle, size: 170), // Increased size
        ),
      ),
    );
  }
}


  String _formatUnitKerja(String unitKerja) {
    if (unitKerja.isEmpty) {
      return 'N/A';
    }

    if (unitKerja.startsWith('TRIAL-')) {
      unitKerja = unitKerja.replaceFirst('TRIAL-', '');
    }

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
      return 'N/A';
    }
  }

  Widget _buildReadOnlyTextField({required String label, required String? value}) {
    return TextField(
      decoration: InputDecoration(
  labelText: label,
  labelStyle: TextStyle(
    color: Color(0xFF0053C5), // Floating label color when focused
  ),
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF0053C5), // Border color when focused
      width: 2.0,
    ),
  ),
)

,
      readOnly: true,
      controller: TextEditingController(text: value ?? 'N/A'),
    );
  }
}
