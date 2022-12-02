class LabOpenDuration {
  String? username;
  int? weeklyMinutes;

  LabOpenDuration({this.username, this.weeklyMinutes});

  LabOpenDuration.fromFirestore(Map<String, dynamic> map)
      : this(username: map["username"], weeklyMinutes: map["weeklyMinutes"]);

  Map<String, dynamic> toFirestore() => {
        if (username != null) "username": username,
        if (weeklyMinutes != null) "weeklyMinutes": weeklyMinutes
      };
}
