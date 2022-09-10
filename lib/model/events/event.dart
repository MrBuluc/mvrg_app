class Event {
  String? title;
  String? location;
  String? imageUrl;
  bool? award;
  int? tokenPrice;
  String? code;

  Event(
      {this.title,
      this.location,
      this.imageUrl,
      this.award,
      this.tokenPrice,
      this.code});

  Event.fromFirestore(Map<String, dynamic> map)
      : this(
            title: map["title"],
            location: map["location"],
            imageUrl: map["imageUrl"],
            award: map["award"],
            tokenPrice: map["tokenPrice"],
            code: map["code"]);

  Map<String, dynamic> toFirestore() => {
        if (title != null) "title": title,
        if (location != null) "location": location,
        if (imageUrl != null) "imageUrl": imageUrl,
        if (award != null) "award": award,
        if (tokenPrice != null) "tokenPrice": tokenPrice,
        if (code != null) "code": code
      };
}
