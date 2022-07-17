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

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  printError(Object e, String methodName) {
    print("Firebase Auth $methodName Hata: " + e.toString());
  }
}
