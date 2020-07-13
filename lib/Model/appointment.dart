class Appointment {
  Appointment(
      {this.date,
      this.status,
      this.myId,
      this.customerName,
      this.phoneNumber,
      this.docId,
      this.review,
      this.reSchedule,
      this.comment});

  String date;
  String phoneNumber;
  String myId;
  String status;
  String customerName;
  String docId;
  String reSchedule;
  String review;
  bool isFuture;
  String comment;
}
