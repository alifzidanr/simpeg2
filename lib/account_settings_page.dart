import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icons_plus/icons_plus.dart'; 
import 'terms_and_conditions_modal.dart'; 
import 'database_helper.dart';
import 'login_page.dart';
import 'privacy_policy_modal.dart'; 
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsPage extends StatefulWidget {
  final String idPegawai;

  AccountSettingsPage({required this.idPegawai});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isExpanded = false;
  bool _isContactExpanded = false; 

 void _updatePassword() async {
  String currentPassword = _currentPasswordController.text;
  String newPassword = _newPasswordController.text;
  String confirmPassword = _confirmPasswordController.text;

  if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Harap isi semua kolom.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (newPassword != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password baru dan konfirmasi tidak cocok.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (newPassword == currentPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password baru tidak boleh sama dengan password saat ini.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  bool isCurrentPasswordValid = await DatabaseHelper.instance.login(widget.idPegawai, currentPassword);
  if (!isCurrentPasswordValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password saat ini salah.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  await DatabaseHelper.instance.updatePassword(widget.idPegawai, newPassword);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('idPegawai');
  await prefs.remove('password');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Password berhasil diubah.',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green,
    ),
  );

  Navigator.pop(context);
}


  void _launchEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': 'Hello',
    },
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'Tidak dapat membuka email app.',
      style: TextStyle(
        fontFamily: 'Roboto', // You don't need Google Fonts if you use Roboto in assets
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.red, // Set background color to red
  ),
);
  }
}

 void _logout() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Konfirmasi Logout',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Tidak',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('password');

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Logout berhasil.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Ya',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}



  void _showTermsAndConditionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows modal to take full height if needed
      backgroundColor: Colors.white, // Sets background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners at the top
        ),
      ),
      builder: (context) => TermsAndConditionsModal(), // Content of the modal
    );
  }

  void _showPrivacyPolicyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows modal to take full height if needed
      backgroundColor: Colors.white, // Sets background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners at the top
        ),
      ),
      builder: (context) => PrivacyPolicyModal(), // Content of the modal
    );
  }

  // Function to open WhatsApp chat
  void _openWhatsApp(String number) async {
    final url = "https://wa.me/$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan Akun',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF0053C5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                // Change Password section
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: ListTile(
                    leading: Icon(Icons.lock, size: 36),
                    title: Text(
                      "Ubah Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Perbarui kata sandi akun Anda agar tetap aman.',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isExpanded ? null : 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        TextField(
                            controller: _currentPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Password saat ini',
                              labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                                color: Color(0xFF0053C5),
                              ),
                              hintText: 'Masukkan password saat ini',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                              ),
                              prefixIcon: Icon(Bootstrap.arrow_repeat),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0053C5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _newPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Password baru',
                              labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                                color: Color(0xFF0053C5),
                              ),
                              hintText: 'Masukkan password baru',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                              ),
                              prefixIcon: Icon(Bootstrap.check2),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0053C5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi password baru',
                              labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                                color: Color(0xFF0053C5),
                              ),
                              hintText: 'Masukkan kembali password baru Anda',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold, // Set the font to bold
                              ),
                              prefixIcon: Icon(Bootstrap.check2_all),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0053C5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _updatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Green background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // 10 Border radius
                                ),
                                foregroundColor: Colors.white, // White font color
                                textStyle: TextStyle(
                                  fontFamily: 'Roboto', // Roboto font
                                  fontWeight: FontWeight.bold, // Bold font
                                ),
                              ),
                              child: Text('Ubah Password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(), // Divider between sections

                // Privacy Policy
                ListTile(
                  leading: Icon(Bootstrap.shield_check, size: 36),
                  onTap: _showPrivacyPolicyModal,
                  title: Text(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Pelajari lebih lanjut tentang cara kami menangani data pribadi Anda sesuai dengan undang-undang privasi.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(),
                // Terms & Conditions
                ListTile(
                  leading: Icon(FontAwesome.file, size: 36),
                  onTap: _showTermsAndConditionsModal,
                  title: Text(
                    'Syarat dan Ketentuan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Baca peraturan dan kebijakan yang Anda setujui saat menggunakan layanan kami.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(),
                // Contact Information Accordion
GestureDetector(
  onTap: () {
    setState(() {
      _isContactExpanded = !_isContactExpanded;
    });
  },
  child: ListTile(
    leading: Icon(Bootstrap.person_lines_fill, size: 36),
    title: Text(
      "Hubungi Kami",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Roboto', // Roboto font bold
      ),
    ),
    subtitle: Text(
      'Hubungi kami melalui email, telepon, atau WhatsApp untuk mendapatkan bantuan.',
      style: TextStyle(fontSize: 14),
    ),
    trailing: Icon(
      _isContactExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
    ),
  ),
),
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  height: _isContactExpanded ? null : 0,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 70.0), // Kept reduced horizontal padding
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
  leading: Icon(Bootstrap.envelope, size: 24),
  title: Text(
    'Email',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      fontFamily: 'Roboto',
    ),
  ),
  subtitle: Text(
    'kesra@al-azhar.or.id',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      fontFamily: 'Roboto',
    ),
  ),
  contentPadding: EdgeInsets.zero,
  trailing: Icon(Bootstrap.arrow_right), // Remove extra padding inside ListTile
  onTap: () {
    _launchEmail('kesra@al-azhar.or.id');
  },
),
        Divider(height: 1), // Reduce height of the divider
        ListTile(
          leading: Icon(Bootstrap.telephone_fill, size: 24),
          title: Text(
            'Telepon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          subtitle: Text(
            '021-7261233 ext: 311',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        Divider(height: 1), // Reduce height of the divider
        ListTile(
          leading: Icon(Bootstrap.whatsapp, size: 24),
          title: Text(
            'WhatsApp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          subtitle: Text(
            '08111995306',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          trailing: Icon(Bootstrap.arrow_right),
          onTap: () {
            _openWhatsApp("628111995306");
          },
          contentPadding: EdgeInsets.zero, // Remove extra padding inside ListTile
        ),
      ],
    ),
  ),
),


// Divider to separate contact information from Logout
Divider(), 

// Logout ListTile with Correct Alignment
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0), // Consistent padding with previous ListTiles
  child: ListTile(
    contentPadding: EdgeInsets.zero, // Aligns the Logout item with the others
    leading: Icon(Bootstrap.box_arrow_right, size: 36, color: Colors.red),
    title: Text(
      'Keluar',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Roboto', // Roboto font bold
        color: Colors.red, // Red font color for Logout
      ),
    ),
    subtitle: Text(
      'Keluar dari akun Anda dengan aman.',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'Roboto', // Roboto font bold
      ),
    ),
    onTap: _logout, // Calling logout function on tap
  ),
),
Divider(), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
