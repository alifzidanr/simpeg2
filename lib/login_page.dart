import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences package
import 'database_helper.dart';
import 'home_page.dart';  // Ensure this import is present

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idPegawaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Check if the user is already logged in
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idPegawai = prefs.getString('idPegawai');
    String? password = prefs.getString('password');

    if (idPegawai != null && password != null) {
      // Automatically log in the user if credentials are found
      bool success = await DatabaseHelper.instance.login(idPegawai, password);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(idPegawai: idPegawai)),
        );
      }
    }
  }

  void _login() async {
    String idPegawai = _idPegawaiController.text;
    String password = _passwordController.text;

    // Use the singleton instance of DatabaseHelper
    bool success = await DatabaseHelper.instance.login(idPegawai, password);
    if (success) {
      // Save the login info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idPegawai', idPegawai);
      await prefs.setString('password', password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(idPegawai: idPegawai)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Incorrect ID Pegawai or password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idPegawaiController,
              decoration: InputDecoration(
                labelText: 'ID Pegawai',
                hintText:'Please input your ID',
                border: OutlineInputBorder(), ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText:'Please input your Password',
                border: OutlineInputBorder(),),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
