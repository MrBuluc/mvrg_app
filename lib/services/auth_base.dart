import '../model/userC.dart';

abstract class AuthBase {
  Future<UserC?> currentUser();
  Future<bool> signOut();
  Future<UserC?> signInWithEmailandPassword(String mail, String password);
  Future<UserC?> createUserWithEmailandPassword(
      String name, String surname, String mail, String password);
  Future<bool> sendPasswordResetEmail(String mail);
}
