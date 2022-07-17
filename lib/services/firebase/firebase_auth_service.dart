import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvrg_app/model/userC.dart';

import '../auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserC> createUserWithEmailandPassword(
      String name, String surname, String mail, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: mail, password: password);
    return UserC(
        id: userCredential.user!.uid,
        mail: mail,
        password: password,
        name: name,
        surname: surname,
        admin: false);
  }

  @override
  Future<UserC?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return Future.value(_userFromFirebase(user));
    } catch (e) {
      printError(e, "currentUser");
      return null;
    }
  }

  UserC? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return UserC(id: user.uid, mail: user.email, name: user.displayName);
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String mail) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: mail);
    } catch (e) {
      printError(e, "sendPasswordResetEmail");
      rethrow;
    }
    return true;
  }

  @override
  Future<UserC?> signInWithEmailandPassword(
      String mail, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: mail, password: password);
    return _userFromFirebase(userCredential.user);
  }

  Future<bool> updateUser(
      String name, String surname, String mail, String password) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user!.email! != mail) {
        await signInWithEmailandPassword(user.email!, password)
            .then((value) => user.updateEmail(mail));
      }

      await user.updateDisplayName(name + " " + surname);
      return true;
    } catch (e) {
      printError(e, "updateUser");
      rethrow;
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      User? user = _firebaseAuth.currentUser;
      await _firebaseAuth.signInWithEmailAndPassword(
          email: user!.email!, password: oldPassword);
      await user.updatePassword(newPassword).catchError((onError) {
        printError(onError, "updatePassword catchError");
        signOut();
        throw onError;
      });
      return true;
    } catch (e) {
      printError(e, "updatePassword");
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      printError(e, "signOut");
      rethrow;
    }
  }

  printError(Object e, String methodName) {
    print("Firebase Auth $methodName Hata: " + e.toString());
  }
}
