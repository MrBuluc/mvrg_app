class UserC {
  String? id;
  String? mail;
  String? name;
  String? surname;
  bool? admin = false;
  String? password;
  int? token;

  UserC(
      {this.id,
      this.mail,
      this.password,
      this.name,
      this.surname,
      this.admin,
      this.token});

  UserC.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            mail: map["mail"],
            name: map["name"],
            surname: map["surname"],
            admin: map["admin"],
            token: map["token"]);

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (name != null) "name": name,
        if (mail != null) "mail": mail,
        if (surname != null) "surname": surname,
        if (admin != null) "admin": admin,
        if (token != null) "token": token
      };

  @override
  String toString() {
    return 'UserC{id: $id, mail: $mail, name: $name, surname: $surname, admin: '
        '$admin, password: $password, token: $token}';
  }
}
