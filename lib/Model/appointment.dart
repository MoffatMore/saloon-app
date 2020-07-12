class Appointment {
  Appointment(
      {this.startDate,
      this.endDate,
      this.status,
      this.myId,
      this.customerName,
      this.phoneNumber,
      this.docId,
      this.review,
      this.reSchedule,
      this.comment});

  String startDate, endDate, phoneNumber;
  String myId;
  String status;
  String customerName;
  String docId;
  String reSchedule;
  String review;
  bool isFuture;
  String comment;
}
