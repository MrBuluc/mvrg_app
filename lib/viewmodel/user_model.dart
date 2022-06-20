import 'package:flutter/cupertino.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/repository/user_repository.dart';
import 'package:mvrg_app/services/auth_base.dart';

import '../locator.dart';

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

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: " + e.toString());
  }
}
