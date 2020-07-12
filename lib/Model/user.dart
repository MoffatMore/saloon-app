class User {
  final String username;
  final String surname;
  final String imageUrl;
  final String id;
  final bool customer;
  final String email;
  final String phone;
  final String profession;
  final String description;
  final String mode;

  User(
      {this.email,
      this.phone,
      this.username,
      this.surname,
      this.imageUrl,
      this.id,
      this.customer,
      this.profession,
      this.description,
      this.mode});

  factory User.fromMap(Map map) {
    String username = map["username"];
    String surname = map["surname"];
    String phone = map["phone"];
    String imageUrl = map["imageUrl"];
    String id = map["id"];
    bool customer = map["mode"] == "Customer";
    String profession = map["profession"];
    String description = map["description"];
    String mode = map["mode"];

    return User(
        customer: customer,
        username: username,
        id: id,
        imageUrl: imageUrl,
        surname: surname,
        phone: phone,
        description: description,
        profession: profession,
        mode: mode);
  }

  Map toMap() {
    return {
      "username": username,
      "surname": surname,
      "imageUrl": imageUrl,
      "id": id,
      "customer": customer.toString()
    };
  }
}
