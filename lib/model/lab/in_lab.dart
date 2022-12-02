import 'package:cloud_firestore/cloud_firestore.dart';

class InLab {
  String? userId;
  String? username;
  Timestamp? arrivalTime;

  InLab({this.userId, this.username, this.arrivalTime});

  InLab.fromFirestore(Map<String, dynamic> map)
      : this(
            userId: map["userId"],
            username: map["username"],
            arrivalTime: map["arrivalTime"]);

  Map<String, dynamic> toFirestore() => {
        if (userId != null) "userId": userId,
        if (username != null) "username": username,
        if (arrivalTime != null) "arrivalTime": arrivalTime
      };
}
