import 'package:firebase_auth/firebase_auth.dart';
import 'package:friday/service/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:friday/pages/home_page.dart';
import 'package:friday/login.dart';

class AuthMethods {
 final FirebaseAuth auth = FirebaseAuth.instance;
 final GoogleSignIn googleSignIn = GoogleSignIn();

 Future<User?> getCurrentUser() async {
    return auth.currentUser;
 }

 Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential result = await auth.signInWithCredential(credential);
        User? userDetails = result.user;

        if (userDetails != null) {
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "imgUrl": userDetails.photoURL,
            "id": userDetails.uid
          };

          await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
 }

 Future<void> signOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogIn()));
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
 }
}
