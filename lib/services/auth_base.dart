import '../model/userC.dart';

abstract class AuthBase {
  Future<UserC?> currentUser();
  Future<bool> signOut();
  Future<UserC?> signInWithEmailandPassword(String mail, String password);
  Future<UserC?> createUserWithEmailandPassword(UserC userC);
  Future<bool> sendPasswordResetEmail(String mail);
}
