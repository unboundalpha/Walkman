import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musicplayer/funtions/firebasefuntions.dart';
import 'package:musicplayer/screens/login.dart';
import 'package:musicplayer/screens/musicgrid.dart'; // Import your MusicGrid screen
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      // Check if user credentials exist in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedEmail = prefs.getString('email');
      String? storedPassword = prefs.getString('password');

      if (storedEmail != null && storedPassword != null) {
        // If credentials exist, directly attempt login
        var response = FirebaseFunctions()
            .Loginuser(storedEmail, storedPassword)
            .then((response) {
          if (response == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicGrid()),
            );
          } else {
            // Handle login error
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          }
        });
      } else {
        // If no credentials, proceed normally to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF070707),
          child: Center(
            child: Text(
              "WALKMAN",
              style: TextStyle(
                color: Color.fromARGB(255, 90, 5, 202),
                fontFamily: "walkman",
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
