import 'package:cloud_firestore/cloud_firestore.dart';

class LabOpen {
  String? id;
  bool? acikMi;
  Timestamp? time;
  String? userName;

  LabOpen({this.id, this.acikMi, this.time, this.userName});

  LabOpen.empty() : this(acikMi: false);

  LabOpen.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            acikMi: map["acikMi"],
            time: map["time"],
            userName: map["userName"]);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (acikMi != null) "acikMi": acikMi,
        if (time != null) "time": time,
        if (userName != null) "userName": userName
      };

  @override
  String toString() {
    return 'LabOpen{id: $id, acikMi: $acikMi, time: $time, userName: $userName}';
  }
}
