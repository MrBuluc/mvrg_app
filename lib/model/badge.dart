class Badge {
  String? imageUrl;
  String? name;
  String? info;
  List? holders;

  Badge({this.imageUrl, this.name, this.info, this.holders});

  Badge.fromJson(Map<String, Object?> json)
      : this(
            imageUrl: json["imageUrl"]! as String,
            name: json["name"]! as String,
            info: json["info"]! as String,
            holders: json["holders"]! as List);

  Map<String, Object?> toJson() =>
      {"imageUrl": imageUrl, "name": name, "info": info, "holders": holders};
}
