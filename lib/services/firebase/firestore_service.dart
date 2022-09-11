import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/events/event.dart';
import 'package:mvrg_app/model/userC.dart';

import '../../model/badges/badgeHolder.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference usersRef, badgesRef, badgeHolderRef, eventsRef;

  FirestoreService() {
    usersRef = _firestore.collection("Users").withConverter<UserC>(
        fromFirestore: (snapshot, _) => UserC.fromJson(snapshot.data()!),
        toFirestore: (userC, _) => userC.toJson());
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

  Future<bool> deleteBadgeHolder(String badgeHolderId) async {
    try {
      await badgeHolderRef.doc(badgeHolderId).delete();
      return true;
    } catch (e) {
      printError("deleteBadgeHolder", e);
      rethrow;
    }
  }

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
      await eventsRef.doc(event.title!).set(event);
      return true;
    } catch (e) {
      printError("setEvent", e);
      rethrow;
    }
  }

  printError(String methodName, Object e) {
    print("firestore $methodName hata: " + e.toString());
  }
}
