class Badge {
  String? id;
  String? imageUrl;
  String? name;
  String? info;

  Badge({this.id, this.imageUrl, this.name, this.info});

  Badge.fromJson(Map<String, dynamic> json)
      : this(
            imageUrl: json["imageUrl"]! as String,
            name: json["name"]! as String,
            info: json["info"]! as String);

  Map<String, dynamic> toJson() =>
      {"imageUrl": imageUrl, "name": name, "info": info};

  Map<String, dynamic> toFirestore() => {
        if (name != null) "name": name,
        if (info != null) "info": info,
        if (imageUrl != null) "imageUrl": imageUrl
      };
}
