import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/resources/storage_methods.dart';

enum AuthErrors {
  Success,
  emailAlreadyExists,
  invalidEmail,
  WeakPassword,
  UnKnow,
  ArentFillAllFields,
  DontSetAvatar,
}

enum LoginErrors {
  DontHaveSuchUSer,
  IncorrectPassword,
  Success,
  ArentFillAllFields,
  UnKnow,
}

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return models.User.fromSnap(snap);
  }

  SignUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    AuthErrors res = AuthErrors.ArentFillAllFields;
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        models.User user = models.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          bio: bio,
          followers: [],
          following: [],
          followingEvents: [],
          followingCleanEvents: [],
          howManyPollutionPointsWereCreted: 0,
          howManyCleanEventsWereVisited: 0,
          howManyEventsWereVisited: 0,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = AuthErrors.Success;
      }
    } on FirebaseAuthException catch (err) {
      print(err.code);
      switch (err.code) {
        case 'email-already-in-use':
          return AuthErrors.emailAlreadyExists;
        case 'invalid-email':
          return AuthErrors.invalidEmail;
        case 'weak-password':
          return AuthErrors.WeakPassword;
      }
    } catch (err) {
      res = AuthErrors.UnKnow;
    }
    return res;
  }

  Future<LoginErrors> loginUser({
    required String email,
    required String password,
  }) async {
    LoginErrors res = LoginErrors.UnKnow;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = LoginErrors.Success;
      } else {
        res = LoginErrors.ArentFillAllFields;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = LoginErrors.DontHaveSuchUSer;
      } else if (e.code == 'wrong-password') {
        res = LoginErrors.IncorrectPassword;
      }
    } catch (err) {
      res = LoginErrors.UnKnow;
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
