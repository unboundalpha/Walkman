import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicplayer/funtions/firebasefuntions.dart';
import 'package:musicplayer/screens/musicgrid.dart';

class MyCreationForm extends StatefulWidget {
  final VoidCallback onTapback;

  MyCreationForm({required this.onTapback});

  @override
  State<MyCreationForm> createState() => _MyCreationFormState();
}

class _MyCreationFormState extends State<MyCreationForm> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Color(0xFF070707),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenWidth * 0.05),
              _buildTextField('E-mail', emailController),
              SizedBox(height: screenWidth * 0.02),
              _buildPasswordTextField(
                  'Enter your password', passwordController),
              SizedBox(height: screenWidth * 0.02),
              _buildPasswordTextField(
                  'Re-enter your password', reenterPasswordController),
              SizedBox(height: screenWidth * 0.02),
              SizedBox(
                height: screenWidth * 0.15,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (passwordController.text.trim() ==
                        reenterPasswordController.text.trim()) {
                      // Passwords match, perform sign-up logic
                      String newemail = emailController.text.trim();
                      String password = passwordController.text.trim();
                      FirebaseFunctions()
                          .registeruser(newemail, password)
                          .then((response) {
                        if (response == null) {
                          Timer(Duration(seconds: 5), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicGrid()));
                          });
                        } else {
                          _showSnackBar('Passwords do not match.');
                        }
                      });
                    } else {
                      // Passwords don't match, show an error or handle accordingly
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 90, 5, 202),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.03,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
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

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(
      String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
