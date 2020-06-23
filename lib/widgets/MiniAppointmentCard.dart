import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/material.dart';

class MiniAppointmentCard extends StatelessWidget {
  final Appointment appointmentData;
  final Function onCardTapped;
  const MiniAppointmentCard({
    @required this.appointmentData,
    @required this.onCardTapped,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Mini appointment Card tapped');
        onCardTapped();
      },
      child: Card(
        elevation: 0.3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: SizeConfig.horizontalBloc * 100,
          height: SizeConfig.verticalBloc * 10.7,
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 3,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        //color: Colors.yellow,
                        child: Text(
                          'Stylist Name: ' + appointmentData.myId,
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 3,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        //color: Colors.pink,
                        child: Text(
                          'Date time: ' + appointmentData.date,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 3,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        //color: Colors.pink,
                        child: Text(
                          'Status: ' + (appointmentData.status ?? 'Pending'),
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
