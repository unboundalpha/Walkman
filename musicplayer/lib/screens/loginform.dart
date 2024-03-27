import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musicplayer/funtions/firebasefuntions.dart';
import 'package:musicplayer/screens/musicgrid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginForm extends StatefulWidget {
  final VoidCallback onTapCreateAccount;

  MyLoginForm({required this.onTapCreateAccount});

  @override
  State<MyLoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  bool isPasswordVisible = false;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenWidth * 0.15,
              child: TextField(
                controller: email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPasswordVisible = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPasswordVisible = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPasswordVisible = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: screenWidth * 0.15,
                      child: Center(
                        child: TextField(
                          controller: password,
                          obscureText: !isPasswordVisible,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.1),
                            ),
                            hintText: 'Password',
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: SvgPicture.asset(
                      'assets/images/visibility.svg',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Center(
              child: SizedBox(
                height: screenWidth * 0.15,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    var response = FirebaseFunctions()
                        .Loginuser(email.text, password.text)
                        .then((response) {
                      if (response == null) {
                        saveCredentials(email.text, password.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MusicGrid()),
                        );
                      } else {
                        // Handle login error
                      }
                    });
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
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save email and password in shared preferences
  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }
}
