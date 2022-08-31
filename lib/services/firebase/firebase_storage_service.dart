import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(
      String anaKlasor, File image, String badgeName) async {
    return await (await _firebaseStorage
            .ref()
            .child(anaKlasor)
            .child(badgeName)
            .child(badgeName + ".png")
            .putFile(image))
        .ref
        .getDownloadURL();
  }
}
