class Appointment {
  Appointment({this.date, this.status, this.myId, this.customerName, this.phoneNumber});

  String date, phoneNumber;
  String myId;
  String status;
  String customerName;
  bool isFuture;
}
