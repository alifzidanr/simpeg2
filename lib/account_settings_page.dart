import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icons_plus/icons_plus.dart'; // Import the icons_plus package
import 'terms_and_conditions_modal.dart'; // Import the modal file
import 'database_helper.dart';
import 'login_page.dart';
import 'privacy_policy_modal.dart'; // Import the new privacy policy modal file
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

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
  bool _isExpanded = false; // For Change Password accordion
  bool _isContactExpanded = false; // For Contact Information accordion

  void _updatePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New password and confirmation do not match.')),
      );
      return;
    }

    bool isCurrentPasswordValid = await DatabaseHelper.instance.login(widget.idPegawai, currentPassword);
    if (!isCurrentPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Current password is incorrect.')),
      );
      return;
    }

    await DatabaseHelper.instance.updatePassword(widget.idPegawai, newPassword);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('idPegawai');
    await prefs.remove('password');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password changed successfully. Please log in again.')),
    );

    Navigator.pop(context);
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('idPegawai');
                await prefs.remove('password');

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Yes'),
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
        SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Settings',
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
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Update your account password to keep it secure.',
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
                            labelText: 'Current Password',
                            hintText: 'Enter your current password',
                            prefixIcon: Icon(Bootstrap.arrow_repeat), // Corresponding icon
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                            prefixIcon: Icon(Bootstrap.check2), // Corresponding icon
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            hintText: 'Re-enter your new password',
                            prefixIcon: Icon(Bootstrap.check2_all), // Corresponding icon
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
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
                              child: Text('Change Password'),
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
                    'Privacy Policy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Learn more about how we handle your personal data in compliance with privacy laws.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(),
                // Terms & Conditions
                ListTile(
                  leading: Icon(FontAwesome.file, size: 36),
                  onTap: _showTermsAndConditionsModal,
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Read the rules and policies you agree to when using our services.',
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
      "Contact Us",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Roboto', // Roboto font bold
      ),
    ),
    subtitle: Text(
      'Reach out to us via email, telephone, or WhatsApp for assistance.',
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
          contentPadding: EdgeInsets.zero, // Remove extra padding inside ListTile
        ),
        Divider(height: 1), // Reduce height of the divider
        ListTile(
          leading: Icon(Bootstrap.telephone_fill, size: 24),
          title: Text(
            'Telephone',
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
      'Logout',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Roboto', // Roboto font bold
        color: Colors.red, // Red font color for Logout
      ),
    ),
    subtitle: Text(
      'Sign out of your account securely.',
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
