import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvrg_app/model/userC.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference usersRef;

  FirestoreService() {
    usersRef = _firestore.collection("Users").withConverter<UserC>(
        fromFirestore: (snapshot, _) => UserC.fromJson(snapshot.data()!),
        toFirestore: (userC, _) => userC.toJson());
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

  printError(String methodName, Object e) {
    print("firestore $methodName hata: " + e.toString());
  }
}
