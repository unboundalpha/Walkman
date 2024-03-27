import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registeruser(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> Loginuser(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null; // Return null for success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message; // Return other error messages
    } catch (e) {
      print(e);
      return 'An unexpected error occurred.'; // Return a generic error message
    }
  }

  Future<String> getAudioUrl(String musiclink) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref(musiclink);

    try {
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error getting download URL: $e");
      return "";
    }
  }
}
