class BadgeHolder {
  String? id;
  String? badgeId;
  String? userId;
  int? rank;

  BadgeHolder({this.id, this.badgeId, this.userId, this.rank});

  BadgeHolder.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"] as String,
            badgeId: map["badgeId"] as String,
            userId: map["userId"] as String,
            rank: map["rank"] as int);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (badgeId != null) "badgeId": badgeId,
        if (userId != null) "userId": userId,
        if (rank != null) "rank": rank
      };
}
