import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/Password accounts are not enabled.';
      } else if (e.code == 'user-disabled') {
        message =
            'The user corresponding to the given email has been disabled.';
      } else if (e.code == 'user-not-found') {
        message = 'No user corresponding to the given email was found.';
      } else {
        message = e.message ?? 'An unknown error occurred.';
      }
      print(message);
    } catch (e) {}
    return null;
  }

  Future<UserCredential?> loginInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/Password accounts are not enabled.';
      } else if (e.code == 'user-disabled') {
        message =
            'The user corresponding to the given email has been disabled.';
      } else if (e.code == 'user-not-found') {
        message = 'No user corresponding to the given email was found.';
      } else if (e.code == 'wrong-password') {
        message =
            'The password is invalid or the user does not have a password.';
      } else {
        message = e.message ?? 'An unknown error occurred.';
      }
      print(message);
    } catch (e) {}
    return null;
  }

  Future<UserCredential?> authGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Người dùng cancel quá trình đăng nhập
        print('Google sign-in was cancelled');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<UserCredential?> authFacebook() async {
    try {
      // Trigger the Facebook authentication flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Obtain the auth details from the request
        final AccessToken accessToken = loginResult.accessToken!;

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        // Sign in to Firebase with the Facebook credential
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        print('Facebook sign-in was cancelled');
        return null;
      } else {
        print('Facebook sign-in failed: ${loginResult.message}');
        return null;
      }
    } catch (e) {
      print('Error during Facebook sign-in: $e');
      return null;
    }
  }

  Future<UserCredential?> authPhone({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
    String? smsCode,
  }) async {
    UserCredential? userCredential;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            userCredential = await _auth.signInWithCredential(credential);
            onVerificationCompleted(credential);
          } catch (e) {
            print('Error during verification completed: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          onVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) async {
          onCodeSent(verificationId, resendToken);
          if (smsCode != null) {
            try {
              final credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: smsCode,
              );
              userCredential = await _auth.signInWithCredential(credential);
            } catch (e) {
              print(e);
            }
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onCodeAutoRetrievalTimeout(verificationId);
        },
      );
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  // Future<UserCredential?> authApple() async {
  //   try {
  //     // Trigger the Apple authentication flow
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [Scope.email, Scope.fullName],
  //     );

  Future<User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      return user;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user corresponding to the given email was found.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else {
        message = e.message ?? 'An unknown error occurred.';
      }
      print(message);
    } catch (e) {
      debugPrint('Error during password reset: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error during account deletion: $e');
    }
  }

  Future<void> updateProfile(String displayName, String photoURL) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.reload();
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error during profile update: $e');
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
        await user.reload();
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error during email update: $e');
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        await user.reload();
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error during password update: $e');
    }
  }

  Future<void> signout() async {
    try {} catch (e) {
      debugPrint('Error during sign out: $e');
    }
  }
}
