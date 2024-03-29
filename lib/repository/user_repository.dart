import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/badges/holder.dart';
import 'package:mvrg_app/model/events/participant.dart';
import 'package:mvrg_app/model/lab/lab_open.dart';
import 'package:mvrg_app/model/lab/lab_open_duration.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/auth_base.dart';
import 'package:mvrg_app/services/firebase/firebase_auth_service.dart';
import 'package:mvrg_app/services/firebase/firebase_storage_service.dart';
import 'package:mvrg_app/services/firebase/firestore_service.dart';
import 'package:mvrg_app/services/http_service.dart';
import 'package:mvrg_app/services/webhook_services/telegram_webhook_service.dart';

import '../locator.dart';
import '../model/badges/badgeHolder.dart';
import '../model/events/event.dart';
import '../model/events/event_participant.dart';
import '../model/lab/in_lab.dart';
import '../services/token_service.dart';
import '../services/webhook_services/discord_webhook_service.dart';

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  final HttpService _httpService = locator<HttpService>();
  final TokenService _tokenService = locator<TokenService>();
  final DiscordWebhookService _discordWebhookService =
      locator<DiscordWebhookService>();
  final TelegramWebhookService _telegramWebhookService =
      locator<TelegramWebhookService>();

  LabOpenDuration? labOpenDuration;

  @override
  Future<UserC?> createUserWithEmailandPassword(UserC newUser) async {
    newUser.weeklyLabOpenMinutes = 0;
    UserC userC =
        await _firebaseAuthService.createUserWithEmailandPassword(newUser);

    bool sonuc = await _firestoreService.setUser(userC);

    if (sonuc) {
      userC = await _firestoreService.readUser(userC.id!);
      userC.password = newUser.password;
      return userC;
    } else {
      return null;
    }
  }

  @override
  Future<UserC?> currentUser() async {
    UserC? userC = await _firebaseAuthService.currentUser();
    if (userC != null) {
      return await readUser(userC.id!);
    } else {
      return null;
    }
  }

  Future<UserC?> readUser(String userId) async {
    UserC userC = await _firestoreService.readUser(userId);
    if (userC.admin!) {
      labOpenDuration = await _firestoreService.getLabOpenDuration(userC.id!);
      if (labOpenDuration != null) {
        userC.weeklyLabOpenMinutes = labOpenDuration!.weeklyMinutes;
      } else {
        userC.weeklyLabOpenMinutes = 0;
      }
    }
    return userC;
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
      userC = await readUser(userC.id!);
      userC!.password = password;
      return userC;
    } else {
      return null;
    }
  }

  Future<bool> updateUserAuth(String id, String name, String surname,
      String mail, String password, bool admin) async {
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

  Future<bool> updateUser(UserC userC) async {
    return await _firestoreService.updateUser(userC.id!, userC.toFirestore());
  }

  Future<List<String>> getBadgeNames() async {
    return await _firestoreService.getBadgeNames();
  }

  Future<List<UserC>> getUsers() async {
    return await _firestoreService.getUsers();
  }

  Future<String> uploadFile(
      String anaKlasor, File file, String fileName) async {
    return await _firebaseStorageService.uploadFile(anaKlasor, file, fileName);
  }

  Future<bool> setBadge(Badge badge) async {
    return await _firestoreService.setBadge(badge);
  }

  Future<bool> updateBadge(Badge badge) async {
    return await _firestoreService.updateBadge(badge.id!, badge.toFirestore());
  }

  Future<bool> addBadgeHolder(BadgeHolder badgeHolder) async {
    List<BadgeHolder> badgeHolders =
        await _firestoreService.getBadgeHolderFromBadgeIdAndUserId(
            badgeHolder.badgeId!, badgeHolder.userId!);
    if (badgeHolders.isEmpty) {
      return await _firestoreService.addBadgeHolder(badgeHolder);
    } else {
      badgeHolder.id = badgeHolders.elementAt(0).id;
      return await updateBadgeHolder(badgeHolder);
    }
  }

  Future<bool> updateBadgeHolder(BadgeHolder badgeHolder) async {
    return await _firestoreService.updateBadgeHolder(
        badgeHolder.id!, badgeHolder.toFirestore());
  }

  Future<int> countBadgeHolderFromBadgeId(String badgeId) async {
    return await _firestoreService.countBadgeHolderFromBadgeId(badgeId);
  }

  Future<List<Holder>> getHolders(String badgeId) async {
    List<Holder> holders = [];
    List<BadgeHolder> badgeHolders =
        await _firestoreService.getBadgeHoldersFromBadgeId(badgeId);
    for (BadgeHolder badgeHolder in badgeHolders) {
      Holder holder = Holder(rank: badgeHolder.rank);
      UserC userC = await _firestoreService.readUser(badgeHolder.userId!);
      holder.name = userC.username;
      holder.badgeHolderId = badgeHolder.id;
      holders.add(holder);
    }
    return holders;
  }

  Future<bool> deleteBadgeHolder(String badgeHolderId) async {
    return await _firestoreService.deleteBadgeHolder(badgeHolderId);
  }

  Stream<QuerySnapshot> badgeStream() => _firestoreService.badgeStream();

  Future<List<String>> getEventsTitles() async {
    return await _firestoreService.getEventsTitles();
  }

  Future<bool> setEvent(Event event) async {
    return await _firestoreService.setEvent(event);
  }

  Future<bool> addEventParticipant(EventParticipant eventParticipant) async {
    List<EventParticipant> eventParticipants =
        await _firestoreService.getEventParticipantFromEventNameAndUserId(
            eventParticipant.eventName!, eventParticipant.userId!);
    if (eventParticipants.isEmpty) {
      return await _firestoreService.addEventParticipant(eventParticipant);
    } else {
      return false;
    }
  }

  Future<List<Participant>> getParticipants(
      String eventName, String currentUserId, bool isParticipant) async {
    List<Participant> participants = [];
    List<EventParticipant> eventParticipants = await _firestoreService
        .getEventParticipantFromEventNameAndIsParticipant(
            eventName, isParticipant);
    for (EventParticipant eventParticipant in eventParticipants) {
      Participant participant =
          Participant(eventParticipantId: eventParticipant.id);
      UserC userC = await _firestoreService.readUser(eventParticipant.userId!);
      participant.name = userC.username;
      participant.isCurrentUser = currentUserId == userC.id!;
      participants.add(participant);
    }
    return participants;
  }

  Future<bool> deleteEventParticipant(String eventParticipantId) async {
    return await _firestoreService.deleteEventParticipant(eventParticipantId);
  }

  Future<bool> joinEvent(String eventCode, String userId) async {
    List<Event> events = await _firestoreService.getEventsFromCode(eventCode);
    String eventTitle = events.elementAt(0).title!;

    List<EventParticipant> eventParticipants = await _firestoreService
        .getEventParticipantFromEventNameAndUserId(eventTitle, userId);
    if (eventParticipants.isNotEmpty) {
      if (!eventParticipants.elementAt(0).isParticipant!) {
        return await _firestoreService.updateEventParticipant(
            eventParticipants.elementAt(0).id!, {"isParticipant": true});
      }
      throw PlatformException(
          code: "0", message: "Bu etkinliğin zaten katıldınız.");
    } else {
      return await _firestoreService.addEventParticipant(EventParticipant(
          eventName: eventTitle, userId: userId, isParticipant: true));
    }
  }

  Future<bool> markEventForDelete(String title, String deletedUserId) async {
    return await _firestoreService.markEventForDelete(title, deletedUserId);
  }

  Future<List<List<String>>> getMyEvents(String userId) async {
    List<String> isParticipantEvents = [], isNotParticipantEvents = [];
    List<EventParticipant> eventParticipants =
        await _firestoreService.getEventParticipantFromUserId(userId);
    for (EventParticipant eventParticipant in eventParticipants) {
      if (eventParticipant.isParticipant!) {
        isParticipantEvents.add(eventParticipant.eventName!);
      } else {
        isNotParticipantEvents.add(eventParticipant.eventName!);
      }
    }
    return [isParticipantEvents, isNotParticipantEvents];
  }

  Future<bool> isThereAnyEventWithCode(String code) async {
    return (await _firestoreService.getEventsFromCode(code)).isNotEmpty;
  }

  Stream<QuerySnapshot> eventsStream() => _firestoreService.eventsStream();

  Future<List<Holder>> getMyBadges(String userId) async {
    List<Holder> holders = [];
    List<Badge> badges = [];
    List<BadgeHolder> badgeHolders =
        await _firestoreService.getBadgeHolderFromUserId(userId);
    badgeHolders.sort();
    for (BadgeHolder badgeHolder in badgeHolders) {
      badges
          .add(await _firestoreService.getBadgeFromDocId(badgeHolder.badgeId!));
    }
    for (int i = 0; i < badgeHolders.length; i++) {
      holders.add(Holder(
          name: badges.elementAt(i).name,
          rank: badgeHolders.elementAt(i).rank,
          badgeImageUrl: badges.elementAt(i).imageUrl));
    }
    return holders;
  }

  Future<String> getTokenBalance(String address) async {
    return await _tokenService.getTokenBalance(address);
  }

  Future<String> sendToken(String receiverAddress, int value) async {
    return await _tokenService.sendToken(receiverAddress, BigInt.from(value));
  }

  Future<LabOpen> labAcikMi() async {
    return (await _firestoreService.labAcikMi())!;
  }

  Future<LabOpen> addLabOpen(bool acikMi, DateTime now, String userName) async {
    LabOpen labOpen = await _firestoreService.addLabOpen(acikMi, now, userName);
    return await _firestoreService.updateLabLastState(labOpen);
  }

  Future<bool> setOrUpdateLabOpenDuration(String userId, String username,
      int newWeeklyMinutes, DateTime labCloseTime) async {
    bool result = await updateLabOpenDurationAndDeleteInLabs(labCloseTime);
    if (result) {
      if (labOpenDuration != null) {
        return await _firestoreService.updateLabOpenDuration(
            userId, newWeeklyMinutes);
      } else {
        return await _firestoreService.setLabOpenDuration(
            userId,
            LabOpenDuration(
                username: username, weeklyMinutes: newWeeklyMinutes));
      }
    }
    return result;
  }

  Future<bool> updateLabOpenDuration(
      String userId, String username, int newDuration) async {
    LabOpenDuration? labOpenDurationLocal =
        await _firestoreService.getLabOpenDuration(userId);
    if (labOpenDurationLocal != null) {
      int newWeeklyMinutes = labOpenDurationLocal.weeklyMinutes! + newDuration;
      return await _firestoreService.updateLabOpenDuration(
          userId, newWeeklyMinutes);
    } else {
      return await _firestoreService.setLabOpenDuration(userId,
          LabOpenDuration(username: username, weeklyMinutes: newDuration));
    }
  }

  Future<bool> updateLabOpenDurationAndDeleteInLabs(
      DateTime labCloseTime) async {
    List<InLab> inLabs = await _firestoreService.getInLabs();
    for (InLab inLab in inLabs) {
      DateTime dateTime = inLab.arrivalTime!.toDate();
      int duration = (labCloseTime.difference(dateTime)).inMinutes;
      bool result =
          await updateLabOpenDuration(inLab.userId!, inLab.username!, duration);
      if (result) {
        await _firestoreService.deleteInLab(inLab.userId!);
      }
    }
    return true;
  }

  Stream<QuerySnapshot> labOpenDurationStream() =>
      _firestoreService.labOpenDurationStream();

  Future<InLab?> getInLab(String userId) async =>
      _firestoreService.getInLab(userId);

  Future<bool> setInLab(InLab inLab) async {
    return await _firestoreService.setInLab(inLab);
  }

  Future<bool> updateLabOpenDurationAndDeleteInLab(
      String userId, String username, int duration) async {
    bool result = await updateLabOpenDuration(userId, username, duration);
    if (result) {
      return await _firestoreService.deleteInLab(userId);
    }
    return false;
  }

  Future<bool> sendMessageToMvRG(String content) async {
    bool result = await _discordWebhookService.sendMessageToMvRGDc(content);
    if (result) {
      return _telegramWebhookService.sendMessageToMvRGTelegram(content);
    }
    return result;
  }

  Future<bool> addTokenTransaction(String userId, int beforeToken,
      int afterToken, String walletAdd, int transferToken) async {
    return await _firestoreService.addTokenTransaction(
        userId, beforeToken, afterToken, walletAdd, transferToken);
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<bool> checkResponse(String url) async {
    return _httpService.checkResponse(url);
  }
}
