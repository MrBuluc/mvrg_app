import 'package:cloud_firestore/cloud_firestore.dart';

class LabOpen {
  bool? acikMi;
  Timestamp? time;
  String? userName;

  LabOpen({this.acikMi, this.time, this.userName});

  LabOpen.fromFirestore(Map<String, dynamic> map) : this(acikMi: map["acikMi"]);

  Map<String, dynamic> toFirestore() => {
        if (acikMi != null) "acikMi": acikMi,
        if (time != null) "time": time,
        if (userName != null) "userName": userName
      };
}
