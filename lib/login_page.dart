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
  // Check if the device is in portrait mode
  bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  return Scaffold(
    body: Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/BG.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Wrapping content with SingleChildScrollView
        SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: isPortrait ? 150.0 : 30.0, // 200px padding in portrait, 50px in landscape
                left: 16.0,
                right: 16.0,
                bottom: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Logo_YPIA.png',
                    height: 200.0, 
                  ),
                  SizedBox(height: 60),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _idPegawaiController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        hintText: 'ID Pegawai',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity, 
                    height: 48.0, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, 
                        foregroundColor: Color(0xFF0053C5), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
