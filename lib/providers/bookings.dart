import 'dart:developer';

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

  static Future<void> editBooking(Map<String, dynamic> data, String id) {
    return Firestore.instance.collection('bookings').document(id).updateData(data);
  }

  static Future<void> deleteBooking(String id) {
    return Firestore.instance.collection("bookings").document(id).delete();
  }

  static Stream<QuerySnapshot> getHairStyles(id) {
    return Firestore.instance.collection("styles").where("stylist", isEqualTo: id).snapshots();
  }

  static Future<void> acceptBooking(String docId) {}

  static Future<void> rateBooking(int rating, String docId, String stylist) {
    log("onSubmitPressed: rating = $rating");
  }
}
