import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? title;
  String? location;
  String? imageUrl;
  bool? award;
  int? tokenPrice;
  String? code;
  Timestamp? createTime;
  bool? isDeleted;
  Timestamp? deletedTime;
  String? deletedUsedId;

  Event(
      {this.title,
      this.location,
      this.imageUrl,
      this.award,
      this.tokenPrice,
      this.code,
      this.createTime,
      this.isDeleted,
      this.deletedTime,
      this.deletedUsedId});

  Event.fromFirestore(Map<String, dynamic> map)
      : this(
            title: map["title"],
            location: map["location"],
            imageUrl: map["imageUrl"],
            award: map["award"],
            tokenPrice: map["tokenPrice"],
            code: map["code"],
            createTime: map["createTime"],
            isDeleted: map["isDeleted"]);

  Map<String, dynamic> toFirestore() => {
        if (title != null) "title": title,
        if (location != null) "location": location,
        if (imageUrl != null) "imageUrl": imageUrl,
        if (award != null) "award": award,
        if (tokenPrice != null) "tokenPrice": tokenPrice,
        if (code != null) "code": code,
        if (createTime != null) "createTime": createTime,
        if (isDeleted != null) "isDeleted": isDeleted,
        if (deletedTime != null) "deletedTime": deletedTime,
        if (deletedUsedId != null) "deletedUsedId": deletedUsedId
      };
}
