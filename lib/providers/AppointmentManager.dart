import 'dart:math';

import 'package:cssalonapp/Model/appointment.dart';

import 'randomData.dart' as RDT;

///Data will e created randomnly
class AppointmentManager {
  static List<Appointment> appointmentList = [];

  static List generateAppointmentList() {
    var randomX = Random().nextInt(7);
    while (randomX == 0) {
      randomX = Random().nextInt(40);
    }
    for (int i = 0; i < randomX; i++) {
      appointmentList.add(Appointment(
        customerName: RDT.lastName[Random().nextInt(RDT.lastName.length)],
        myId: RDT.mames[Random().nextInt(RDT.mames.length)],
        date: Random().nextInt(29).toString() +
            ' Jan 2020n' +
            Random().nextInt(12).toString() +
            'am - ' +
            Random().nextInt(12).toString() +
            'pm',
        phoneNumber: Random().nextInt(333333333).toString(),
      ));
      if (Random().nextInt(2) == 0)
      //true
      {
        appointmentList[i].isFuture = true;
      }
      //false
      else {
        appointmentList[i].isFuture = false;
      }
    }
    print('List is successfully generated');
    return appointmentList;
  }
}
