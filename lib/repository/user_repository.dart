import 'dart:io';

import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/auth_base.dart';
import 'package:mvrg_app/services/firebase/firebase_auth_service.dart';
import 'package:mvrg_app/services/firebase/firebase_storage_service.dart';
import 'package:mvrg_app/services/firebase/firestore_service.dart';

import '../locator.dart';

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<UserC?> createUserWithEmailandPassword(
      String name, String surname, String mail, String password) async {
    UserC userC = await _firebaseAuthService.createUserWithEmailandPassword(
        name, surname, mail, password);

    bool sonuc = await _firestoreService.setUser(userC);

    if (sonuc) {
      userC = await _firestoreService.readUser(userC.id!);
      userC.password = password;
      return userC;
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
  Future<UserC?> signInWithEmailandPassword(
      String mail, String password) async {
    UserC? userC =
        await _firebaseAuthService.signInWithEmailandPassword(mail, password);
    if (userC != null) {
      userC = await _firestoreService.readUser(userC.id!);
      userC.password = password;
      return userC;
    } else {
      return null;
    }
  }

  Future<bool> updateUser(String id, String name, String surname, String mail,
      String password, bool admin) async {
    bool sonuc =
        await _firebaseAuthService.updateUser(name, surname, mail, password);
    if (sonuc) {
      return await _firestoreService.setUser(UserC(
          id: id, mail: mail, name: name, surname: surname, admin: admin));
    }
    return sonuc;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    return await _firebaseAuthService.updatePassword(oldPassword, newPassword);
  }

  Future<List<String>> getBadgeNames() async {
    return await _firestoreService.getBadgeNames();
  }

  Future<String> uploadFile(
      String anaKlasor, File image, String badgeName) async {
    return await _firebaseStorageService.uploadFile(
        anaKlasor, image, badgeName);
  }

  Future<bool> setBadge(Badge badge) async {
    return await _firestoreService.setBadge(badge);
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
