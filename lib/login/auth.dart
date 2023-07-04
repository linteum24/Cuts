import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuts/main/home.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? name;
String? userEmail;
String? imageUrl;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future<User?> signInWithGoogle(BuildContext context) async {
  User? user;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  NetworkUser _network = NetworkUser();

  if (kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(authProvider);

      user = userCredential.user;

      prefs.setString('email', user!.email!);
      prefs.setString('id', user.uid);
    } catch (e) {
      print(e);
    }
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        user = userCredential.user;

        prefs.setString('email', user!.email!);
        prefs.setString('id', user.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRegisterCuts', true);
  }

  return user;
}

Future<User?> signInWithFacebook() async {
  User? user;
  final prefs = await SharedPreferences.getInstance();

  if (kIsWeb) {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(facebookProvider);

      user = userCredential.user;

      prefs.setString('email', user!.email!);
      prefs.setString('id', user.uid);
    } catch (e) {
      print(e);
    }
  } else {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult != null) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final AuthCredential credential =
          FacebookAuthProvider.credential(facebookAuthCredential.toString());

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user = userCredential.user;

        prefs.setString('email', user!.email!);
        prefs.setString('id', user.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRegisterCuts', true);
  }

  return user;
}
