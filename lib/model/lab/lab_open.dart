import 'package:cloud_firestore/cloud_firestore.dart';

class LabOpen {
  String? id;
  bool? acikMi;
  Timestamp? time;
  String? username;

  LabOpen({this.id, this.acikMi, this.time, this.username});

  LabOpen.empty() : this(acikMi: false);

  LabOpen.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            acikMi: map["acikMi"],
            time: map["time"],
            username: map["username"]);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (acikMi != null) "acikMi": acikMi,
        if (time != null) "time": time,
        if (username != null) "username": username
      };

  @override
  String toString() {
    return 'LabOpen{id: $id, acikMi: $acikMi, time: $time, username: $username}';
  }
}
