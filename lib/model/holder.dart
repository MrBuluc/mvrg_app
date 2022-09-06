class Holder {
  String? name;
  int? rank;

  Holder({this.name, this.rank});

  Holder.fromMap(Map<String, dynamic> map)
      : this(name: map["name"], rank: map["rank"]);
}
