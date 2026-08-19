import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/utils/auth_error_messages.dart';

void main() {
  group('authErrorMessage', () {
    test('maps known codes to friendly text', () {
      expect(
        authErrorMessage(FirebaseAuthException(code: 'weak-password')),
        contains('stronger password'),
      );
      expect(
        authErrorMessage(FirebaseAuthException(code: 'network-request-failed')),
        contains('internet connection'),
      );
    });

    test('does not reveal whether an account exists', () {
      final notFound =
          authErrorMessage(FirebaseAuthException(code: 'user-not-found'));
      final wrongPassword =
          authErrorMessage(FirebaseAuthException(code: 'wrong-password'));
      expect(notFound, equals(wrongPassword));
    });

    test('never leaks the raw exception for unknown errors', () {
      final message = authErrorMessage(
        FirebaseAuthException(
            code: 'some-internal-code', message: 'INTERNAL x'),
      );
      expect(message, 'Something went wrong. Please try again.');
      expect(message, isNot(contains('INTERNAL')));
    });

    test('handles non-Firebase errors', () {
      expect(
        authErrorMessage(Exception('boom')),
        'Something went wrong. Please try again.',
      );
    });
  });
}
