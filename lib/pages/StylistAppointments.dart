import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/pages/profile.dart';
import 'package:cssalonapp/pages/upload-pics.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';
import 'mini-appointment.dart';

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
    reload();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
    reload();
  }

  reload() {
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (isFirstTime == false) {
      initiateList();
      isFirstTime = true;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
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
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => UploadPictures()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.autorenew,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () async {
                reload();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings_power,
                color: Colors.black54,
                size: SizeConfig.horizontalBloc * 8,
              ),
              onPressed: () => _authProvider.signOut(),
            ),
          ],
        ),
        body: isLoading
            ? SizedBox()
            : Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(.15),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 9, top: 7),
                              child: new Container(
                                width: SizeConfig.safeBlockHorizontal * 90,
                                //color: Colors.pink,
                                child: Text(
                                  'Welcome Back !',
                                  style: TextStyle(
                                      fontSize: SizeConfig.horizontalBloc * 6,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 15),
                              child: new Container(
                                width: SizeConfig.safeBlockHorizontal * 90,
                                //color: Colors.pink,
                                child: Text(
                                  _authProvider.currentUser.username ??
                                      'Stylist',
                                  style: TextStyle(
                                    fontSize: SizeConfig.horizontalBloc * 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 9, left: 20),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 90,
                          //color: Colors.pink,
                          child: Text(
                            'Next appointments',
                            style: TextStyle(
                                fontSize: SizeConfig.horizontalBloc * 5,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Bookings.myAppointments(
                                _authProvider.currentUser.username),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      color: Color(0xffF3F6FF).withOpacity(0.5),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var app = Appointment(
                                            startDate: snapshot.data
                                                .documents[index]['start_date'],
                                            endDate: snapshot.data
                                                .documents[index]['end_date'],
                                            myId: snapshot.data.documents[index]
                                                ['customerUid'],
                                            customerName:
                                                snapshot.data.documents[index]
                                                    ['customerName'],
                                            phoneNumber:
                                                snapshot.data.documents[index]
                                                    ['customerPhone'],
                                            status: snapshot.data
                                                .documents[index]['status'],
                                            docId: snapshot.data
                                                .documents[index].documentID,
                                            reSchedule:
                                                snapshot.data.documents[index]
                                                    ['schedule-date'],
                                            review: snapshot.data
                                                .documents[index]['review'],
                                          );
                                          return MyMiniAppointmentCard(
                                            onCardTapped: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                          AppointmentDetailScreen(
                                                        appointmentData: app,
                                                      )));
                                            },
                                            key: Key(Random()
                                                .nextInt(4000)
                                                .toString()),
                                            appointmentData: app,
                                          );
                                        },
                                      )),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 9, left: 20),
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 90,
                                  height: SizeConfig.verticalBloc * 3,
                                  //color: Colors.pink,
                                  child: Text(
                                    'No appointments at the moments!',
                                    style: TextStyle(
                                        fontSize: SizeConfig.horizontalBloc * 3,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  )
                ],
              ));
  }

  ///I use this function to make an aggragated list
  ///this list will then be feeded into the listview"builder
  ///IMPORTANT : Using this function i understood
  ///that gicving keys to child widget is important if you are
  ///panning on rebuilding them dynamically by adding custom parameters
  Future<bool> initiateList() async {
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
