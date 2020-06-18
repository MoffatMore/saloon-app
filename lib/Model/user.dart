class User {
  final String username;
  final String surname;
  final String imageUrl;
  final String id;
  final bool admin;
  final String email;
  final String phone;

  User({
    this.email,
    this.phone,
    this.username,
    this.surname,
    this.imageUrl,
    this.id,
    this.admin,
  });

  factory User.fromMap(Map map) {
    String username = map["username"];
    String surname = map["surname"];
    String imageUrl = map["imageUrl"];
    String id = map["id"];
    bool admin = map["admin"] == "true";

    return User(admin: admin, username: username, id: id, imageUrl: imageUrl, surname: surname);
  }

  Map toMap() {
    return {
      "username": username,
      "surname": surname,
      "imageUrl": imageUrl,
      "id": id,
      "admin": admin.toString()
    };
  }
}
