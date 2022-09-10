class Event {
  String? title;
  String? location;
  String? imageUrl;
  List<String>? participants;
  bool? award;
  int? tokenPrice;

  Event(
      {this.title,
      this.location,
      this.imageUrl,
      this.participants,
      this.award,
      this.tokenPrice});

  Event.fromFirestore(Map<String, dynamic> map)
      : this(
            title: map["title"],
            location: map["location"],
            imageUrl: map["imageUrl"],
            participants: map["participants"],
            award: map["award"],
            tokenPrice: map["tokenPrice"]);

  Map<String, dynamic> toFiresstore() => {
        if (title != null) "title": title,
        if (location != null) "location": location,
        if (imageUrl != null) "imageUrl": imageUrl,
        if (participants != null) "participants": participants,
        if (award != null) "award": award,
        if (tokenPrice != null) "tokenPrice": tokenPrice
      };
}
