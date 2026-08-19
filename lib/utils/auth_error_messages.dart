import 'package:firebase_auth/firebase_auth.dart';

/// Maps FirebaseAuthException codes to messages that are safe and useful to
/// show a user. Falls back to a generic message so raw exception strings
/// (which leak internal detail) never reach the UI.
String authErrorMessage(Object error) {
  if (error is! FirebaseAuthException) {
    return 'Something went wrong. Please try again.';
  }

  switch (error.code) {
    case 'invalid-email':
      return 'That email address looks incorrect.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      // Deliberately vague: distinguishing these lets an attacker enumerate
      // which email addresses have accounts.
      return 'Incorrect email or password.';
    case 'email-already-in-use':
      return 'An account already exists for that email.';
    case 'weak-password':
      return 'Please choose a stronger password (at least 6 characters).';
    case 'operation-not-allowed':
      return 'This sign-in method is not enabled.';
    case 'too-many-requests':
      return 'Too many attempts. Please wait a moment and try again.';
    case 'network-request-failed':
      return 'No internet connection. Please check your network.';
    case 'requires-recent-login':
      return 'Please sign in again before making this change.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
