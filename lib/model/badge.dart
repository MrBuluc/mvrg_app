class Badge {
  String? id;
  String? imageUrl;
  String? name;
  String? info;
  List<Map<String, dynamic>>? holders;

  Badge({this.imageUrl, this.name, this.info, this.holders});

  Badge.fromJson(Map<String, dynamic> json)
      : this(
            imageUrl: json["imageUrl"]! as String,
            name: json["name"]! as String,
            info: json["info"]! as String,
            holders: json["holders"] is Iterable
                ? List.from(json["holders"])
                : null);

  Map<String, dynamic> toJson() =>
      {"imageUrl": imageUrl, "name": name, "info": info, "holders": holders};

  Map<String, dynamic> toFirestore() => {
        "name": name,
        "info": info,
        "imageUrl": imageUrl,
        if (holders != null) "holders": holders
      };
}
