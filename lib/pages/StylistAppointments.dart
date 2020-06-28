import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/pages/upload-pics.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/widgets/MiniAppointmentCard.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class StylistAppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<StylistAppointmentScreen> {
  bool isFirstTime = false;
  bool isLoading = true;
  List<Widget> topHeader;
  List<Widget> currentAppointment;
  List<Widget> midHeader;
  List<Widget> futureAppointment;
  List<Widget> finalList;
  AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    topHeader = [];
    currentAppointment = [];
    midHeader = [];
    futureAppointment = [];
    finalList = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (isFirstTime == false) {
      initiateList();
      isFirstTime = true;
    }
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xffF3F6FF).withOpacity(0.134),
          elevation: 0,
          leading: Icon(
            Icons.menu,
            color: Colors.black54,
            size: SizeConfig.horizontalBloc * 8,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person_pin,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () async {},
            ),
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UploadPictures()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings_power,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                topHeader..clear();
                currentAppointment..clear();
                midHeader..clear();
                futureAppointment.clear();
                finalList..clear();
                initiateList();

                Future.delayed(Duration(milliseconds: 375), () {
                  isLoading = false;
                  setState(() {});
                });
              },
            )
          ],
        ),
        body: isLoading
            ? SizedBox()
            : StreamBuilder<QuerySnapshot>(
                stream: Bookings.myAppointments(_authProvider.currentUser.username),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  int len = 0;
                  if (snapshot.hasData) {
                    for (int index = 0; index < snapshot.data.documents.length; index++) {
                      len++;
                      var app = Appointment(
                          date: snapshot.data.documents[index]['date'],
                          myId: snapshot.data.documents[index]['customerUid'],
                          customerName: snapshot.data.documents[index]['customerName'],
                          phoneNumber: snapshot.data.documents[index]['customerPhone'],
                          status: snapshot.data.documents[index]['status']);
                      futureAppointment.add(Center(
                          child: MiniAppointmentCard(
                        onCardTapped: () {},
                        appointmentData: app,
                      )));
                      finalList.addAll(futureAppointment);
                    }
                    if (snapshot.data.documents.length == 0) {
                      len++;
                      log((snapshot.data.documents.length == 0).toString());
                      futureAppointment.add(Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 9, left: 20),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 90,
                          height: SizeConfig.verticalBloc * 3,
                          //color: Colors.pink,
                          child: Text(
                            'No appointments at the moments!',
                            style: TextStyle(
                                fontSize: SizeConfig.horizontalBloc * 3,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ));
                      finalList.addAll(futureAppointment);
                    }
                  }

                  return Container(
                    color: Color(0xffF3F6FF).withOpacity(0.134),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: len + 3,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: -20,
                              child: FadeInAnimation(child: finalList[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ));
  }

  ///I use this function to make an aggragated list
  ///this list will then be feeded into the listview"builder
  ///IMPORTANT : Using this function i understood
  ///that gicving keys to child widget is important if you are
  ///panning on rebuilding them dynamically by adding custom parameters
  Future<bool> initiateList() async {
    //First we work on the header of the list
    topHeader.add(
      Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 9, top: 7),
        child: new Container(
          width: SizeConfig.safeBlockHorizontal * 90,
          height: SizeConfig.verticalBloc * 3,
          //color: Colors.pink,
          child: Text(
            'Welcome Back !',
            style: TextStyle(fontSize: SizeConfig.horizontalBloc * 6, color: Colors.black45),
          ),
        ),
      ),
    );
    topHeader.add(
      Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 15),
        child: new Container(
          width: SizeConfig.safeBlockHorizontal * 90,
          height: SizeConfig.verticalBloc * 5,
          //color: Colors.pink,
          child: Text(
            _authProvider.currentUser.username ?? 'Stylist',
            style: TextStyle(
              fontSize: SizeConfig.horizontalBloc * 9.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );

    midHeader.add(
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 9, left: 20),
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 90,
          height: SizeConfig.verticalBloc * 3,
          //color: Colors.pink,
          child: Text(
            'Next appointments',
            style: TextStyle(fontSize: SizeConfig.horizontalBloc * 5, color: Colors.black45),
          ),
        ),
      ),
    );

    // We create the final list that will be passed to the
    //listView.builder
    finalList.addAll(topHeader);
    finalList.addAll(currentAppointment);
    finalList.addAll(midHeader);

    if (isFirstTime == false) {
      isLoading = false;
      setState(() {});
    }
    setState(() {});
    return true;
  }
}
