class EventParticipant {
  String? id;
  String? eventName;
  String? userId;
  bool? isParticipant;

  EventParticipant({this.id, this.eventName, this.userId, this.isParticipant});

  EventParticipant.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            eventName: map["eventName"],
            userId: map["userId"],
            isParticipant: map["isParticipant"]);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (eventName != null) "eventName": eventName,
        if (userId != null) "userId": userId,
        if (isParticipant != null) "isParticipant": isParticipant
      };
}
