import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/screens/creationform.dart';
import 'package:musicplayer/screens/loginform.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool existingFlag = true;
  bool creationFlag = false;
  String pagetype = "Sign in";
  String navigationType = "Create Account";
  String accountType = "Not a Member? ";

  void changeLoginToCreation() {
    setState(() {
      existingFlag = false;
      creationFlag = true;
      pagetype = "Create Account";
      navigationType = "Log in";
      accountType = "Do you have an account? ";
    });
  }

  void changeCreationToLogin() {
    setState(() {
      existingFlag = true;
      creationFlag = false;
      navigationType = "Create Account";
      pagetype = "Sign in";
      accountType = "Not a Member? ";
    });
  }

  void toggleForms() {
    if (existingFlag) {
      changeLoginToCreation();
    } else {
      changeCreationToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Container(
          color: Color(0xFF070707),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.05),
                Center(
                  child: Text(
                    "WALKMAN",
                    style: TextStyle(
                        color: Color.fromARGB(255, 90, 5, 202),
                        fontFamily: "walkman",
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
                Text(
                  pagetype,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.07,
                    fontFamily: 'Satoshi',
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "If you need any support click here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.025,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: screenWidth,
                      maxHeight: screenWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: existingFlag,
                          child: Expanded(
                            flex: 1,
                            child: MyLoginForm(
                              onTapCreateAccount: changeLoginToCreation,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: creationFlag,
                          child: Expanded(
                            flex: 1,
                            child: MyCreationForm(
                              onTapback: changeCreationToLogin,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.025,
                    fontFamily: 'Satoshi',
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/google.svg'),
                      SizedBox(width: screenWidth * 0.05),
                      SvgPicture.asset('assets/images/apple.svg'),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                Center(
                  child: GestureDetector(
                    onTap: toggleForms,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(accountType,
                            style: TextStyle(color: Colors.white)),
                        Text(
                          navigationType,
                          style: TextStyle(
                            color: Color.fromARGB(255, 90, 5, 202),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
