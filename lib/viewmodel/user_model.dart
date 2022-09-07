import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/repository/user_repository.dart';
import 'package:mvrg_app/services/auth_base.dart';

import '../locator.dart';
import '../model/badgeHolder.dart';
import '../model/holder.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.idle;
  final UserRepository _userRepository = locator<UserRepository>();
  UserC? _user;

  ViewState get state => _state;

  UserC? get user => _user;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<UserC?> createUserWithEmailandPassword(
      String name, String surname, String mail, String password) async {
    try {
      state = ViewState.busy;
      return await _userRepository.createUserWithEmailandPassword(
          name, surname, mail, password);
    } catch (e) {
      printError("createUserWithEmailandPassword", e);
      rethrow;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserC?> currentUser() async {
    try {
      state = ViewState.busy;
      _user = await _userRepository.currentUser();
      if (_user != null) {
        notifyListeners();
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      printError("currentUser", e);
      return null;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String mail) async {
    try {
      return await _userRepository.sendPasswordResetEmail(mail);
    } catch (e) {
      printError("sendPasswordResetEmail", e);
      rethrow;
    }
  }

  @override
  Future<UserC?> signInWithEmailandPassword(
      String mail, String password) async {
    try {
      UserC? userC =
          await _userRepository.signInWithEmailandPassword(mail, password);
      if (userC != null) {
        _user = userC;
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      printError("signInWithEmailandPassword", e);
      rethrow;
    }
  }

  Future<bool> updateUser(String id, String name, String surname, String mail,
      String password, bool admin) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.updateUser(
          id, name, surname, mail, password, admin);
      if (sonuc) {
        _user = UserC(
            id: id, mail: mail, name: name, surname: surname, admin: admin);
        return true;
      }
      return sonuc;
    } catch (e) {
      printError("updateUser", e);
      rethrow;
    } finally {
      state = ViewState.idle;
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      return await _userRepository.updatePassword(oldPassword, newPassword);
    } catch (e) {
      printError("updatePassword", e);
      rethrow;
    }
  }

  Future<List<String>> getBadgeNames() async {
    try {
      return await _userRepository.getBadgeNames();
    } catch (e) {
      printError("getBadgeNames", e);
      rethrow;
    }
  }

  Future<List<UserC>> getUsers() async {
    try {
      return await _userRepository.getUsers();
    } catch (e) {
      printError("getUserNames", e);
      rethrow;
    }
  }

  Future<String> uploadFile(
      String anaKlasor, File image, String badgeName) async {
    try {
      state = ViewState.busy;
      return await _userRepository.uploadFile(anaKlasor, image, badgeName);
    } catch (e) {
      printError("uploadFile", e);
      rethrow;
    } finally {
      state = ViewState.idle;
    }
  }

  Future<bool> setBadge(Badge badge) async {
    try {
      return await _userRepository.setBadge(badge);
    } catch (e) {
      printError("setBadge", e);
      rethrow;
    }
  }

  Future<bool> updateBadge(Badge badge) async {
    try {
      return await _userRepository.updateBadge(badge);
    } catch (e) {
      printError("updateBadge", e);
      rethrow;
    }
  }

  Future<bool> addBadgeHolder(BadgeHolder badgeHolder) async {
    try {
      return await _userRepository.addBadgeHolder(badgeHolder);
    } catch (e) {
      printError("addBadgeHolder", e);
      rethrow;
    }
  }

  Future<bool> updateBadgeHolder(BadgeHolder badgeHolder) async {
    try {
      return await _userRepository.updateBadgeHolder(badgeHolder);
    } catch (e) {
      printError("updateBadgeHolder", e);
      rethrow;
    }
  }

  Future<int> countBadgeHolderFromBadgeId(String badgeId) async {
    try {
      return await _userRepository.countBadgeHolderFromBadgeId(badgeId);
    } catch (e) {
      printError("countBadgeHolderFromBadgeId", e);
      rethrow;
    }
  }

  Future<List<Holder>> getHolders(String badgeId) async {
    try {
      return await _userRepository.getHolders(badgeId);
    } catch (e) {
      printError("getHolders", e);
      rethrow;
    }
  }

  Future<bool> deleteBadgeHolder(String badgeHolderId) async {
    try {
      return await _userRepository.deleteBadgeHolder(badgeHolderId);
    } catch (e) {
      printError("deleteBadgeHolder", e);
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.busy;
      bool result = await _userRepository.signOut();
      if (result) {
        _user = null;
      }
      return result;
    } catch (e) {
      printError("signOut", e);
      rethrow;
    } finally {
      state = ViewState.idle;
    }
  }

  Future<bool> checkResponse(String url) async {
    try {
      return _userRepository.checkResponse(url);
    } catch (e) {
      printError("checkResponse", e);
      rethrow;
    }
  }

  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: " + e.toString());
  }
}
