import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(
      String anaKlasor, File file, String fileName) async {
    return await (await _firebaseStorage
            .ref()
            .child(anaKlasor)
            .child(fileName)
            .child(fileName + ".png")
            .putFile(file))
        .ref
        .getDownloadURL();
  }
}
