import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/model/userC.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference usersRef, badgesRef;

  FirestoreService() {
    usersRef = _firestore.collection("Users").withConverter<UserC>(
        fromFirestore: (snapshot, _) => UserC.fromJson(snapshot.data()!),
        toFirestore: (userC, _) => userC.toJson());
    badgesRef = _firestore.collection("Badges").withConverter<Badge>(
        fromFirestore: (snapshot, _) => Badge.fromJson(snapshot.data()!),
        toFirestore: (badge, _) => badge.toJson());
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

  Future<List<String>> getUserNames() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docSnapshotList =
        (await _firestore.collection("Users").get()).docs;
    List<String> userNames = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot
        in docSnapshotList) {
      userNames.add(queryDocumentSnapshot.data()["name"] +
          " " +
          queryDocumentSnapshot.data()["surname"]);
    }
    return userNames;
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

  printError(String methodName, Object e) {
    print("firestore $methodName hata: " + e.toString());
  }
}
