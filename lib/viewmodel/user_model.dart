import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/events/event_participant.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/repository/user_repository.dart';
import 'package:mvrg_app/services/auth_base.dart';

import '../locator.dart';
import '../model/badges/badgeHolder.dart';
import '../model/badges/holder.dart';
import '../model/events/event.dart';
import '../model/events/participant.dart';

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
  Future<UserC?> createUserWithEmailandPassword(UserC userC) async {
    try {
      state = ViewState.busy;
      return await _userRepository.createUserWithEmailandPassword(userC);
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

  Future<bool> updateUserAuth(String id, String name, String surname,
      String mail, String password, bool admin) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.updateUserAuth(
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

  Future<bool> updateUserStore(UserC newUser) async {
    try {
      return await _userRepository.updateUserStore(newUser);
    } catch (e) {
      printError("updateUserStore", e);
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
      String anaKlasor, File file, String fileName) async {
    try {
      state = ViewState.busy;
      return await _userRepository.uploadFile(anaKlasor, file, fileName);
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

  Future<List<String>> getEventsTitles() async {
    try {
      return await _userRepository.getEventsTitles();
    } catch (e) {
      printError("getEventsTitles", e);
      rethrow;
    }
  }

  Future<bool> setEvent(Event event) async {
    try {
      return await _userRepository.setEvent(event);
    } catch (e) {
      printError("methodName", e);
      rethrow;
    }
  }

  Future<bool> addEventParticipant(String eventName, bool isParticipant) async {
    try {
      return await _userRepository.addEventParticipant(EventParticipant(
          eventName: eventName,
          userId: user!.id!,
          isParticipant: isParticipant));
    } catch (e) {
      printError("addEventParticipant", e);
      rethrow;
    }
  }

  Future<List<Participant>> getParticipants(
      String eventName, bool isParticipant) async {
    try {
      return await _userRepository.getParticipants(
          eventName, user!.id!, isParticipant);
    } catch (e) {
      printError("getParticipant", e);
      rethrow;
    }
  }

  Future<bool> deleteEventParticipant(String eventParticipantId) async {
    try {
      return await _userRepository.deleteEventParticipant(eventParticipantId);
    } catch (e) {
      printError("deleteEventParticipant", e);
      rethrow;
    }
  }

  Future<bool> joinEvent(String eventCode) async {
    try {
      return await _userRepository.joinEvent(eventCode, user!.id!);
    } catch (e) {
      printError("joinEvent", e);
      rethrow;
    }
  }

  Future<List<List<String>>> getMyEvents() async {
    try {
      return await _userRepository.getMyEvents(user!.id!);
    } catch (e) {
      printError("getMyEvents", e);
      rethrow;
    }
  }

  Future<bool> isThereAnyEventWithCode(String code) async {
    try {
      return await _userRepository.isThereAnyEventWithCode(code);
    } catch (e) {
      printError("isThereAnyEventWithCode", e);
      rethrow;
    }
  }

  Future<List<Holder>> getMyBadges() async {
    try {
      return await _userRepository.getMyBadges(user!.id!);
    } catch (e) {
      printError("getMyBadges", e);
      rethrow;
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

  Future<String> getTokenBalance(String address) async {
    try {
      return await _userRepository.getTokenBalance(address);
    } catch (e) {
      printError("getBalance", e);
      rethrow;
    }
  }

  Future<String> sendToken(String receiverAddress, int value) async {
    try {
      return await _userRepository.sendToken(receiverAddress, value);
    } catch (e) {
      printError("sendToken", e);
      rethrow;
    }
  }

  Future<bool> labAcikMi() async {
    try {
      return await _userRepository.labAcikMi();
    } catch (e) {
      printError("labAcikMi", e);
      rethrow;
    }
  }

  Future<bool> addLabOpen(bool acikMi) async {
    try {
      return await _userRepository.addLabOpen(
          acikMi, user!.name! + " " + user!.surname!);
    } catch (e) {
      printError("addLabOpen", e);
      rethrow;
    }
  }

  Future<bool> sendMessageToMvRG(bool acikMi) async {
    try {
      String content = "${user!.name} ${user!.surname} labı ";
      content += acikMi ? "açtı. ✅" : "kapattı. ❌";
      return await _userRepository.sendMessageToMvRG(content);
    } catch (e) {
      printError("sendMessageToMvRG", e);
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

  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: " + e.toString());
  }
}
