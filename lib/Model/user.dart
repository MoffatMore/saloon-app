class User {
  final String username;
  final String surname;
  final String imageUrl;
  final String id;
  final bool customer;
  final String email;
  final String phone;

  User({
    this.email,
    this.phone,
    this.username,
    this.surname,
    this.imageUrl,
    this.id,
    this.customer,
  });

  factory User.fromMap(Map map) {
    String username = map["username"];
    String surname = map["surname"];
    String phone = map["phone"];
    String imageUrl = map["imageUrl"];
    String id = map["id"];
    bool customer = map["mode"] == "Customer";

    return User(
        customer: customer,
        username: username,
        id: id,
        imageUrl: imageUrl,
        surname: surname,
        phone: phone);
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
