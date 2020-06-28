import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  static book(
      {String stylist,
      String customerUid,
      String customerName,
      String customerPhone,
      String date,
      String reason,
      String description}) async {
    var reference = Firestore.instance.collection("bookings").document();
    await reference.setData({
      'stylist': stylist,
      'customerUid': customerUid,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'date': date,
      'status': 'pending',
      'reason': reason
    });
  }

  static Stream<QuerySnapshot> getHairCareStyList(String title) {
    var reference =
        Firestore.instance.collection("profile").where('profession', isEqualTo: title).snapshots();
    return reference;
  }

  static Stream<QuerySnapshot> getHairStylist() {
    var snapshot =
        Firestore.instance.collection('profile').where('mode', isEqualTo: 'Stylist').snapshots();
    return snapshot;
  }

  static Stream<QuerySnapshot> myAppointments(String username) {
    var snapshot =
        Firestore.instance.collection('bookings').where('stylist', isEqualTo: username).snapshots();
    return snapshot;
  }
}
