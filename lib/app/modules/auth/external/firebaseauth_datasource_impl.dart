import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../domain/entities/user_entity.dart';
import '../infra/datasources/auth_datasource.dart';
import '../../../shared/exceptions/failure_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../shared/exceptions/auth_exception.dart';
import '../../../shared/exceptions/firebase_auth_exception.dart';

class FirebaseauthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseauthDatasourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<UserEntity> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw ErrorGoogleSignIn();
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw NoUserFound();
      } else {
        final user = userCredential.user;
        return UserEntity(
            uid: user!.uid,
            name: user.displayName!,
            email: user.email!,
            photoUrl: user.photoURL!);
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthErros(e.code);
    } on PlatformException catch (err, s) {
      if (err.code == 'sign_in_canceled') {
        throw NoUserFound();
      }
      if (err.code == "network_error") {
        throw NoInternetConnection();
      } else {
        throw UnknownError(
            errorMessage: err.toString(),
            exception: err,
            stackTrace: s,
            label:
                "FirebaseAuthDatasourceImpl"); // Throws PlatformException again because it wasn't the one we wanted
      }
    }
  }

  @override
  Future<void> signOut() async {
    _googleSignIn.disconnect();
    _firebaseAuth.signOut();
  }

  @override
  Stream<UserEntity?> checkSignedUser() {
    return _firebaseAuth.authStateChanges().map((user) => user == null
        ? null
        : UserEntity(
            uid: user.uid,
            name: user.displayName,
            photoUrl: user.photoURL,
            email: user.email,
          ));
  }

  @override
  UserEntity? get user => (_firebaseAuth.currentUser == null)
      ? null
      : UserEntity(
          uid: _firebaseAuth.currentUser!.uid,
          name: _firebaseAuth.currentUser!.displayName,
          photoUrl: _firebaseAuth.currentUser!.photoURL,
          email: _firebaseAuth.currentUser!.email,
        );
}
