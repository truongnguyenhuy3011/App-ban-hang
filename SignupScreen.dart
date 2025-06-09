import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  final String firebaseApiKey = 'AIzaSyBAKqiA3sGXdpqtPdfbi7qL3RIqTwOs2os';

  Future<void> signupFirebase(String email, String password) async {
    final String endpoint =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseApiKey';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      // Đăng ký thành công
      return;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error']['message']);
    }
  }

  void signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Vui lòng nhập đầy đủ thông tin.";
      });
      return;
    }

    try {
      await signupFirebase(email, password);
      // Đăng ký thành công, quay về màn hình đăng nhập
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Thành công'),
          content: Text('Đăng ký tài khoản thành công!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // đóng dialog
                Navigator.of(context).pop(); // quay về LoginScreen
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FA),
      appBar: AppBar(title: Text('Đăng ký')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Icon(Icons.app_registration, size: 80, color: Colors.blueAccent),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: signup,
                icon: Icon(Icons.app_registration),
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("Đăng ký", style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
