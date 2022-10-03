import 'package:cloud_firestore/cloud_firestore.dart';

class LabOpen {
  bool? acikMi;
  Timestamp? time;
  String? userId;

  LabOpen({this.acikMi, this.time, this.userId});

  LabOpen.fromFirestore(Map<String, dynamic> map)
      : this(acikMi: map["acikMi"], time: map["time"]);

  Map<String, dynamic> toFirestore() => {
        if (acikMi != null) "acikMi": acikMi,
        if (time != null) "time": time,
        if (userId != null) "userId": userId
      };
}
