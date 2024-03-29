import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/events/event.dart';
import 'package:mvrg_app/model/events/event_participant.dart';
import 'package:mvrg_app/model/lab/in_lab.dart';
import 'package:mvrg_app/model/lab/lab_open.dart';
import 'package:mvrg_app/model/lab/lab_open_duration.dart';
import 'package:mvrg_app/model/local_settings.dart';
import 'package:mvrg_app/model/token_transaction.dart';
import 'package:mvrg_app/model/userC.dart';

import '../../model/badges/badgeHolder.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference usersRef,
      badgesRef,
      badgeHolderRef,
      eventsRef,
      eventParticipantRef,
      labOpenRef,
      labLastState,
      tokenTransactionRef,
      labOpenDurationRef,
      inLabRef;
  late DocumentReference labLastStateDocRef;

  FirestoreService() {
    usersRef = _firestore.collection("Users").withConverter<UserC>(
        fromFirestore: (snapshot, _) => UserC.fromFirestore(snapshot.data()!),
        toFirestore: (userC, _) => userC.toFirestore());
    badgesRef = _firestore.collection("Badges").withConverter<Badge>(
        fromFirestore: (snapshot, _) => Badge.fromJson(snapshot.data()!),
        toFirestore: (badge, _) => badge.toJson());
    badgeHolderRef = _firestore
        .collection("BadgeHolders")
        .withConverter<BadgeHolder>(
            fromFirestore: (snapshot, _) =>
                BadgeHolder.fromFirestore(snapshot.data()!),
            toFirestore: (badgeHolder, _) => badgeHolder.toFirestore());
    eventsRef = _firestore.collection("Events").withConverter<Event>(
        fromFirestore: (snapshot, _) => Event.fromFirestore(snapshot.data()!),
        toFirestore: (event, _) => event.toFirestore());
    eventParticipantRef = _firestore
        .collection("EventParticipant")
        .withConverter<EventParticipant>(
            fromFirestore: (snapshot, _) =>
                EventParticipant.fromFirestore(snapshot.data()!),
            toFirestore: (eventParticipant, _) =>
                eventParticipant.toFirestore());
    labOpenRef = _firestore
        .collection(LocalSettings.test ? "LabOpenTest" : "LabOpen")
        .withConverter<LabOpen>(
            fromFirestore: (snapshot, _) =>
                LabOpen.fromFirestore(snapshot.data()!),
            toFirestore: (labOpen, _) => labOpen.toFirestore());
    labLastState = _firestore.collection("LabLastState").withConverter<LabOpen>(
        fromFirestore: (snapshot, _) => LabOpen.fromFirestore(snapshot.data()!),
        toFirestore: (labLastState, _) => labLastState.toFirestore());
    labLastStateDocRef = labLastState.doc("1");
    tokenTransactionRef = _firestore
        .collection("TokenTransaction")
        .withConverter<TokenTransaction>(
            fromFirestore: (snapshot, _) =>
                TokenTransaction.fromFirestore(snapshot.data()!),
            toFirestore: (tokenTransaction, _) =>
                tokenTransaction.toFirestore());
    labOpenDurationRef = _firestore
        .collection("LabOpenDuration")
        .withConverter<LabOpenDuration>(
            fromFirestore: (snapshot, _) =>
                LabOpenDuration.fromFirestore(snapshot.data()!),
            toFirestore: (labOpenDuration, _) => labOpenDuration.toFirestore());
    inLabRef = _firestore.collection("InLab").withConverter<InLab>(
        fromFirestore: ((snapshot, _) => InLab.fromFirestore(snapshot.data()!)),
        toFirestore: (inLab, _) => inLab.toFirestore());
  }

  Future<UserC> readUser(String userId) async {
    return (await usersRef
        .doc(userId)
        .get()
        .then((snapshot) => snapshot.data()!)) as UserC;
  }

  Future<bool> setUser(UserC userC) async {
    try {
      await usersRef.doc(userC.id).set(userC);
      return true;
    } catch (e) {
      printError("setUser", e);
      return false;
    }
  }

  Future<bool> updateUser(String id, Map<String, dynamic> userMap) async {
    try {
      await usersRef.doc(id).update(userMap);
      return true;
    } catch (e) {
      printError("updateUser", e);
      rethrow;
    }
  }

  Future<List<String>> getBadgeNames() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection("Badges").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docSnapshotList =
        querySnapshot.docs;
    List<String> badgeNames = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
        in docSnapshotList) {
      badgeNames.add(docSnapshot.data()["name"]);
    }
    return badgeNames;
  }

  Future<List<UserC>> getUsers() async {
    try {
      List<UserC> users = [];
      List<QueryDocumentSnapshot<UserC>> queryDocumentSnapshotList =
          (await usersRef.get()).docs as List<QueryDocumentSnapshot<UserC>>;
      for (QueryDocumentSnapshot<UserC> queryDocumentSnapshot
          in queryDocumentSnapshotList) {
        users.add(queryDocumentSnapshot.data());
      }
      return users;
    } catch (e) {
      printError("getUsers", e);
      rethrow;
    }
  }

  Future<bool> setBadge(Badge badge) async {
    try {
      await badgesRef.add(badge);
      return true;
    } catch (e) {
      printError("setBadge", e);
      rethrow;
    }
  }

  Future<bool> updateBadge(String id, Map<String, dynamic> badgeMap) async {
    try {
      await badgesRef.doc(id).update(badgeMap);
      return true;
    } catch (e) {
      printError("updateBadge", e);
      rethrow;
    }
  }

  Future<Badge> getBadgeFromDocId(String docId) async {
    return (await badgesRef.doc(docId).get()).data()! as Badge;
  }

  Future<bool> addBadgeHolder(BadgeHolder badgeHolder) async {
    try {
      String docId = (await badgeHolderRef.add(badgeHolder)).id;
      return await updateBadgeHolder(docId, {"id": docId});
    } catch (e) {
      printError("addBadgeHolder", e);
      rethrow;
    }
  }

  Future<bool> updateBadgeHolder(
      String id, Map<String, dynamic> badgeHolderMap) async {
    try {
      await badgeHolderRef.doc(id).update(badgeHolderMap);
      return true;
    } catch (e) {
      printError("updateBadgeHolder", e);
      rethrow;
    }
  }

  Future<int> countBadgeHolderFromBadgeId(String badgeId) async {
    try {
      return (await badgeHolderRef.where("badgeId", isEqualTo: badgeId).get())
          .size;
    } catch (e) {
      printError("countBadgeHolderFromBadgeId", e);
      rethrow;
    }
  }

  Future<List<BadgeHolder>> getBadgeHolderFromBadgeIdAndUserId(
      String badgeId, String userId) async {
    try {
      List<BadgeHolder> badgeHolders = [];
      List<QueryDocumentSnapshot<BadgeHolder>> queryDocSnapshotList =
          (await badgeHolderRef
                  .where("badgeId", isEqualTo: badgeId)
                  .where("userId", isEqualTo: userId)
                  .get())
              .docs as List<QueryDocumentSnapshot<BadgeHolder>>;
      for (QueryDocumentSnapshot<BadgeHolder> queryDocumentSnapshot
          in queryDocSnapshotList) {
        badgeHolders.add(queryDocumentSnapshot.data());
      }
      return badgeHolders;
    } catch (e) {
      printError("countBadgeHolderFromBadgeIdAndUserId", e);
      rethrow;
    }
  }

  Future<List<BadgeHolder>> getBadgeHoldersFromBadgeId(String badgeId) async {
    try {
      List<BadgeHolder> badgeHolders = [];
      List<QueryDocumentSnapshot<BadgeHolder>> queryDocSnapshotList =
          (await badgeHolderRef.where("badgeId", isEqualTo: badgeId).get()).docs
              as List<QueryDocumentSnapshot<BadgeHolder>>;
      for (QueryDocumentSnapshot<BadgeHolder> queryDocumentSnapshot
          in queryDocSnapshotList) {
        badgeHolders.add(queryDocumentSnapshot.data());
      }
      return badgeHolders;
    } catch (e) {
      printError("getBadgeHoldersFromBadgeId", e);
      rethrow;
    }
  }

  Future<List<BadgeHolder>> getBadgeHolderFromUserId(String userId) async {
    List<BadgeHolder> badgeHolders = [];
    List<QueryDocumentSnapshot<BadgeHolder>> queryDocSSnapshotList =
        (await badgeHolderRef.where("userId", isEqualTo: userId).get()).docs
            as List<QueryDocumentSnapshot<BadgeHolder>>;
    for (QueryDocumentSnapshot<BadgeHolder> queryDocumentSnapshot
        in queryDocSSnapshotList) {
      badgeHolders.add(queryDocumentSnapshot.data());
    }
    return badgeHolders;
  }

  Future<bool> deleteBadgeHolder(String badgeHolderId) async {
    try {
      await badgeHolderRef.doc(badgeHolderId).delete();
      return true;
    } catch (e) {
      printError("deleteBadgeHolder", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> badgeStream() => badgesRef.snapshots();

  Future<List<String>> getEventsTitles() async {
    List<String> eventsTitles = [];

    List<QueryDocumentSnapshot<Event>> queryDocSnapshotList =
        (await eventsRef.get()).docs as List<QueryDocumentSnapshot<Event>>;

    for (QueryDocumentSnapshot<Event> queryDocumentSnapshot
        in queryDocSnapshotList) {
      eventsTitles.add(queryDocumentSnapshot.data().title!);
    }
    return eventsTitles;
  }

  Future<bool> setEvent(Event event) async {
    try {
      event.createTime = Timestamp.now();
      await eventsRef.doc(event.title!).set(event);
      return true;
    } catch (e) {
      printError("setEvent", e);
      rethrow;
    }
  }

  Future<List<Event>> getEventsFromCode(String code) async {
    List<Event> events = [];
    List<QueryDocumentSnapshot<Event>> queryDocSnapshotList =
        (await eventsRef.where("code", isEqualTo: code).get()).docs
            as List<QueryDocumentSnapshot<Event>>;
    for (QueryDocumentSnapshot<Event> queryDocumentSnapshot
        in queryDocSnapshotList) {
      events.add(queryDocumentSnapshot.data());
    }
    return events;
  }

  Future<bool> markEventForDelete(String title, String deletedUserId) async {
    try {
      await eventsRef.doc(title).update({
        "isDeleted": true,
        "deletedTime": Timestamp.now(),
        "deleledUsedId": deletedUserId
      });
      return true;
    } catch (e) {
      printError("markEventForDelete", e);
      rethrow;
    }
  }

  Future<bool> addEventParticipant(EventParticipant eventParticipant) async {
    try {
      String docId = (await eventParticipantRef.add(eventParticipant)).id;
      return await updateEventParticipant(docId, {"id": docId});
    } catch (e) {
      printError("addEventParticipant", e);
      rethrow;
    }
  }

  Future<bool> updateEventParticipant(
      String id, Map<String, dynamic> eventParticipantMap) async {
    try {
      await eventParticipantRef.doc(id).update(eventParticipantMap);
      return true;
    } catch (e) {
      printError("updateEventParticipant", e);
      rethrow;
    }
  }

  Future<List<EventParticipant>>
      getEventParticipantFromEventNameAndUserIdAndIsParticipant(
          String eventName, String userId, bool isParticipant) async {
    try {
      List<EventParticipant> eventParticipants = [];
      List<QueryDocumentSnapshot<EventParticipant>> queryDocSnapshotList =
          (await eventParticipantRef
                  .where("eventName", isEqualTo: eventName)
                  .where("userId", isEqualTo: userId)
                  .where("isParticipant", isEqualTo: isParticipant)
                  .get())
              .docs as List<QueryDocumentSnapshot<EventParticipant>>;
      for (QueryDocumentSnapshot<EventParticipant> queryDocumentSnapshot
          in queryDocSnapshotList) {
        eventParticipants.add(queryDocumentSnapshot.data());
      }
      return eventParticipants;
    } catch (e) {
      printError(
          "getEventParticipantFromEventNameAndUserIdAndIsParticipant", e);
      rethrow;
    }
  }

  Future<List<EventParticipant>>
      getEventParticipantFromEventNameAndIsParticipant(
          String eventName, bool isParticipant) async {
    try {
      List<EventParticipant> eventParticipants = [];
      List<QueryDocumentSnapshot<EventParticipant>> queryDocSnapshotList =
          (await eventParticipantRef
                  .where("eventName", isEqualTo: eventName)
                  .where("isParticipant", isEqualTo: isParticipant)
                  .get())
              .docs as List<QueryDocumentSnapshot<EventParticipant>>;
      for (QueryDocumentSnapshot<EventParticipant> queryDocumentSnapshot
          in queryDocSnapshotList) {
        eventParticipants.add(queryDocumentSnapshot.data());
      }
      return eventParticipants;
    } catch (e) {
      printError("getEventParticipantFromEventName", e);
      rethrow;
    }
  }

  Future<List<EventParticipant>> getEventParticipantFromEventNameAndUserId(
      String eventName, String userId) async {
    try {
      List<EventParticipant> eventParticipants = [];
      List<QueryDocumentSnapshot<EventParticipant>> queryDocSnapshotList =
          (await eventParticipantRef
                  .where("eventName", isEqualTo: eventName)
                  .where("userId", isEqualTo: userId)
                  .get())
              .docs as List<QueryDocumentSnapshot<EventParticipant>>;
      for (QueryDocumentSnapshot<EventParticipant> queryDocumentSnapshot
          in queryDocSnapshotList) {
        eventParticipants.add(queryDocumentSnapshot.data());
      }
      return eventParticipants;
    } catch (e) {
      printError("getEventParticipantFromEventNameAndUserId", e);
      rethrow;
    }
  }

  Future<List<EventParticipant>> getEventParticipantFromUserId(
      String userId) async {
    List<EventParticipant> eventParticipants = [];
    List<QueryDocumentSnapshot<EventParticipant>> queryDocSnapshotList =
        (await eventParticipantRef.where("userId", isEqualTo: userId).get())
            .docs as List<QueryDocumentSnapshot<EventParticipant>>;
    for (QueryDocumentSnapshot<EventParticipant> queryDocumentSnapshot
        in queryDocSnapshotList) {
      eventParticipants.add(queryDocumentSnapshot.data());
    }
    return eventParticipants;
  }

  Future<EventParticipant> getEventParticipant(
      String eventParticipantId) async {
    return (await eventParticipantRef
        .doc(eventParticipantId)
        .get()
        .then((snapshot) => snapshot.data()!)) as EventParticipant;
  }

  Future<bool> deleteEventParticipant(String eventParticipantId) async {
    try {
      await eventParticipantRef.doc(eventParticipantId).delete();
      return true;
    } catch (e) {
      printError("deleteEventParticipant", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> eventsStream() => eventsRef
      .orderBy("createTime", descending: true)
      .where("isDeleted", isEqualTo: false)
      .snapshots();

  Future<LabOpen?> labAcikMi() async {
    return (await labLastStateDocRef.get().then((snapshot) => snapshot.data()))
        as LabOpen?;
  }

  Future<LabOpen> addLabOpen(bool acikMi, DateTime now, String userName) async {
    try {
      LabOpen labOpen = LabOpen(
          acikMi: acikMi, time: Timestamp.fromDate(now), username: userName);
      String docId = (await labOpenRef.add(labOpen)).id;
      await updateLabOpen(docId, {"id": docId});
      labOpen.id = docId;
      return labOpen;
    } catch (e) {
      printError("addLabOpen", e);
      rethrow;
    }
  }

  Future updateLabOpen(String id, Map<String, dynamic> updateMap) async {
    try {
      await labOpenRef.doc(id).update(updateMap);
    } catch (e) {
      printError("updateLabOpen", e);
      rethrow;
    }
  }

  Future<LabOpen> updateLabLastState(LabOpen labOpen) async {
    try {
      await labLastStateDocRef.update(labOpen.toFirestore());
      return labOpen;
    } catch (e) {
      printError("updateLabLastState", e);
      rethrow;
    }
  }

  Future<bool> setLabOpenDuration(
      String userId, LabOpenDuration labOpenDuration) async {
    try {
      await labOpenDurationRef.doc(userId).set(labOpenDuration);
      return true;
    } catch (e) {
      printError("setLabOpenDuration", e);
      rethrow;
    }
  }

  Future<LabOpenDuration?> getLabOpenDuration(String userId) async {
    return (await labOpenDurationRef
        .doc(userId)
        .get()
        .then((snapshot) => snapshot.data())) as LabOpenDuration?;
  }

  Future<bool> updateLabOpenDuration(
      String userId, int newWeeklyMinutes) async {
    try {
      await labOpenDurationRef
          .doc(userId)
          .update({"weeklyMinutes": newWeeklyMinutes});
      return true;
    } catch (e) {
      printError("updateLabOpenDuration", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> labOpenDurationStream() =>
      labOpenDurationRef.orderBy("weeklyMinutes", descending: true).snapshots();

  Future<InLab?> getInLab(String userId) async =>
      (await inLabRef.doc(userId).get().then((snapshot) => snapshot.data()))
          as InLab?;

  Future<bool> setInLab(InLab inLab) async {
    try {
      inLab.arrivalTime = Timestamp.now();
      await inLabRef.doc(inLab.userId!).set(inLab);
      return true;
    } catch (e) {
      printError("setInLab", e);
      rethrow;
    }
  }

  Future<List<InLab>> getInLabs() async {
    List<InLab> inLabs = [];
    List<QueryDocumentSnapshot<InLab>> queryDocSnapshotList =
        (await inLabRef.get()).docs as List<QueryDocumentSnapshot<InLab>>;
    for (QueryDocumentSnapshot<InLab> queryDocumentSnapshot
        in queryDocSnapshotList) {
      inLabs.add(queryDocumentSnapshot.data());
    }
    return inLabs;
  }

  Future<bool> deleteInLab(String userId) async {
    try {
      await inLabRef.doc(userId).delete();
      return true;
    } catch (e) {
      printError("deleteInLab", e);
      rethrow;
    }
  }

  Future<bool> addTokenTransaction(String userId, int beforeToken,
      int afterToken, String walletAdd, int transferToken) async {
    try {
      await tokenTransactionRef.add(TokenTransaction(
          userId: userId,
          beforeToken: beforeToken,
          afterToken: afterToken,
          walletAdd: walletAdd,
          transferToken: transferToken,
          time: Timestamp.now()));
      return true;
    } catch (e) {
      printError("addTokenTransaction", e);
      rethrow;
    }
  }

  printError(String methodName, Object e) {
    print("firestore $methodName hata: " + e.toString());
  }
}
