import 'package:flutter/material.dart';
import 'database_helper.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String? currentPassword, newPassword, confirmPassword;
  String namaLengkap = '', nip = '';
  final String idPegawai = 'your_id'; // Set this accordingly

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  // Load employee data (nama_lengkap and nip)
  Future<void> _loadEmployeeData() async {
    final dbHelper = DatabaseHelper.instance;
    final employee = await dbHelper.getEmployeeProfile(idPegawai);
    if (employee != null) {
      setState(() {
        namaLengkap = employee['nama_lengkap'] ?? '';
        nip = employee['nip'] ?? '';
      });
    }
  }

  // Handle password change logic
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final dbHelper = DatabaseHelper.instance;

    // Verify current password
    final isValid = await dbHelper.login(idPegawai, currentPassword!);
    if (!isValid) {
      _showSnackbar('Current password is incorrect');
      return;
    }

    // Check if new password matches confirmation
    if (newPassword != confirmPassword) {
      _showSnackbar('New password and confirm password do not match');
      return;
    }

    // Update the password in the database
    await dbHelper.updatePassword(idPegawai, newPassword!);  // No encryption needed

    _showSnackbar('Password changed successfully');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0053C5),
        title: Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Lengkap: $namaLengkap', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('NIP: $nip', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                    onChanged: (value) {
                      currentPassword = value;
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter your current password' : null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    onChanged: (value) {
                      newPassword = value;
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter a new password' : null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please confirm your password' : null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Confirm'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
