import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../pages/HomePage.dart';

class AuthClass {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<void> googleSignInMethod(BuildContext context) async {
    try {
      print('Starting Google Sign-in...');
      
      // Check if Google Play Services is available
      bool isAvailable = await googleSignIn.isSignedIn();
      print('Google Sign-in available: $isAvailable');
      
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      print('Google Sign-in account: ${googleSignInAccount?.email}');

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        if (googleSignInAuthentication.idToken == null) {
          throw Exception('Google Sign-in failed: No ID token received');
        }

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
          await auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          
          print('Google Sign-in successful: ${userCredential.user?.email}');

          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        } catch (error) {
          print('Firebase auth error: $error');
          String errorMessage = 'Authentication failed';
          
          if (error.toString().contains('network')) {
            errorMessage = 'Network error. Please check your internet connection.';
          } else if (error.toString().contains('account-exists-with-different-credential')) {
            errorMessage = 'An account with this email exists with different credentials.';
          }
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        print('Google Sign-in cancelled by user');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google Sign-in was cancelled'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error) {
      print('Google Sign-in error: $error');
      String errorMessage = 'Google Sign-in failed';
      
      if (error.toString().contains('sign_in_failed') || 
          error.toString().contains('SIGN_IN_FAILED')) {
        errorMessage = 'Google Sign-in not available. Please use email/password login or try again later.';
      } else if (error.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: 'token', value: userCredential.credential?.token.toString());
    await storage.write(
        key: 'userCredential', value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: 'token');
      await storage.deleteAll(); // Clear all stored data
      print('User logged out successfully');
    }
    catch (e) {
      print('Logout error: $e');
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context , Function setData) async {
    PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, 'Verification code sent');
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      showSnackBar(context, 'Verification failed');
    };

    PhoneCodeSent codeSent = (String verificationId, int? forceResendingToken) async {
      showSnackBar(context, 'Verification code sent');
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) async {
      showSnackBar(context, 'Time out');
    };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
    showSnackBar(context, 'Error: $e');
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> verifyCode(String verificationId, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      await auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }
}
