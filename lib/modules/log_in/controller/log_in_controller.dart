import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginController extends ChangeNotifier {
  final googleSign = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<void> googleLogIn() async {
    try {
      EasyLoading.show();
      final googleAccount = await googleSign.signIn();
      if (googleAccount == null) return;
      _user = googleAccount;

      final googleAuth = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
    notifyListeners();
  }

  Future<void> googleLogout() async {
    try {
      EasyLoading.show();
      await googleSign.disconnect();
      FirebaseAuth.instance.signOut();
      _user = null;
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
