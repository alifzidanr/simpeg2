import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icons_plus/icons_plus.dart'; // Import the icons_plus package
import 'terms_and_conditions_modal.dart'; // Import the modal file
import 'database_helper.dart';
import 'login_page.dart';
import 'privacy_policy_modal.dart'; // Import the new privacy policy modal file

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
  bool _isExpanded = false; // Control the expansion of the accordion

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

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Bootstrap.shield_check, size: 36), // Smaller icon size
                      onTap: _showPrivacyPolicyModal,
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Slightly smaller font size
                        ),
                      ),
                      subtitle: Text(
                        'Learn more about how we handle your personal data in compliance with privacy laws.',
                        style: TextStyle(fontSize: 14), // Smaller subtitle font
                      ),
                    ),
                    Divider(), // Adds a divider between list items
                    ListTile(
                      leading: Icon(FontAwesome.file, size: 36), // Smaller icon size
                      onTap: _showTermsAndConditionsModal,
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Slightly smaller font size
                        ),
                      ),
                      subtitle: Text(
                        'Read the rules and policies you agree to when using our services.',
                        style: TextStyle(fontSize: 14), // Smaller subtitle font
                      ),
                    ),
                    Divider(), // This divider separates Terms & Conditions from Change Password
                  ],
                ),
              ),

              // Custom Accordion for Change Password
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          hintText: 'Enter your current password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter your new password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          hintText: 'Re-enter your new password',
                          border: OutlineInputBorder(),
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
              SizedBox(height: 250),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _logout,
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red background
                    foregroundColor: Colors.white, // White font color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rectangle with 10 border radius
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold, // Bold font
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
