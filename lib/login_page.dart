import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_page.dart';  // <-- Ensure this import is present

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idPegawaiController = TextEditingController();  // <-- Changed controller name
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String idPegawai = _idPegawaiController.text;  // <-- Changed field to id_pegawai
    String password = _passwordController.text;

    bool success = await DatabaseHelper().login(idPegawai, password);  // <-- Pass id_pegawai instead of nip
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(idPegawai: idPegawai)),  // Pass idPegawai here
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
              controller: _idPegawaiController,  // <-- Changed input field to id_pegawai
              decoration: InputDecoration(labelText: 'ID Pegawai'),  // <-- Updated label
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
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
