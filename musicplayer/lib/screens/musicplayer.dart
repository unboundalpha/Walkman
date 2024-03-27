import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicplayer/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDD8amF2jYHf5pv6d5w8eTRraSIBmcA8_8",
          appId: "1:758458488621:android:85028753ab2527abf225a4",
          messagingSenderId: "",
          projectId: "walkman-7ad21",
          storageBucket: "walkman-7ad21.appspot.com"));
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
