class User{
  int user_id;
  String user_name;
  String user_password;
  String user_region;
  String user_gender;

  User(this.user_id, this.user_name, this.user_password, this.user_region, this.user_gender);

  factory User.fromJson(Map<String, dynamic> json) => User(
    int.parse(json["user_id"]),
      json["user_name"],
      json["user_password"],
      json["user_region"],
      json["user_gender"]
  );

  Map<String, dynamic> toJson() => {
    "user_id" : user_id.toString(),
    "user_name" : user_name,
    "user_password" : user_password,
    "user_region" : user_region,
    "user_gender" : user_gender
  };
}