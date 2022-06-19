class UserC {
  String? id;
  String? mail;
  String? name;
  String? surname;
  bool? admin = false;

  UserC({this.id, this.mail, this.name, this.surname, this.admin});

  UserC.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"]! as String,
            mail: json["mail"]! as String,
            name: json["name"]! as String,
            surname: json["surname"]! as String,
            admin: json["admin"]! as bool);

  Map<String, Object?> toJson() => {
        "id": id,
        "name": name,
        "mail": mail,
        "surname": surname,
        "admin": admin
      };
}
