class EventParticipants {
  String? id;
  String? eventName;
  String? userId;

  EventParticipants({this.id, this.eventName, this.userId});

  EventParticipants.fromFirestore(Map<String, dynamic> map)
      : this(id: map["id"], eventName: map["eventName"], userId: map["userId"]);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (eventName != null) "eventName": eventName,
        if (userId != null) "userId": userId
      };
}
