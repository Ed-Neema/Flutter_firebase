import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_firebase/screens/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home_page.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // REGISTER USER
  Future<User?> register(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(" Account Created Successfully"),
        backgroundColor: Colors.greenAccent,
      ));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  // LOGIN USER
  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(" Log in Successful"),
        backgroundColor: Colors.greenAccent,
      ));
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  // Signout
  Future<User?> signout(BuildContext context) async {
    try {
      // for google
      await GoogleSignIn().signOut();
      await firebaseAuth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(" Logged out Successfully"),
        backgroundColor: Colors.greenAccent,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${error.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  // Google signin
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // trigger authentication dialog
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // obtain auth details from request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // create a new credential
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        // once signed in, return user data from firebase
        // and sign them in
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(" Logged in Successfully"),
          backgroundColor: Colors.greenAccent,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return userCredential.user;
      }
    } catch (error) {
      print(error);
    }
  }
}
