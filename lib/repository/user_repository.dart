import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/auth_base.dart';
import 'package:mvrg_app/services/firebase/firebase_auth_service.dart';
import 'package:mvrg_app/services/firebase/firestore_service.dart';

import '../locator.dart';

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Future<UserC?> createUserWithEmailandPassword(
      String name, String surname, String mail, String password) async {
    UserC userC = await _firebaseAuthService.createUserWithEmailandPassword(
        name, surname, mail, password);

    bool sonuc = await _firestoreService.setUser(userC);

    if (sonuc) {
      return await _firestoreService.readUser(userC.id!);
    } else {
      return null;
    }
  }

  @override
  Future<UserC?> currentUser() async {
    UserC? userC = await _firebaseAuthService.currentUser();
    if (userC != null) {
      return await _firestoreService.readUser(userC.id!);
    } else {
      return null;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String mail) async {
    return await _firebaseAuthService.sendPasswordResetEmail(mail);
  }

  @override
  Future<UserC?> signInWithEmailandPassword(String mail, String password) {
    // TODO: implement signInWithEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
