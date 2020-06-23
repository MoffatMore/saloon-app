import 'dart:developer' as developer;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/providers/AppointmentManager.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/widgets/AppointmentCard.dart';
import 'package:cssalonapp/widgets/MiniAppointmentCard.dart';
import 'package:cssalonapp/widgets/SlidingCard.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'appointment_details.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool isFirstTime = false;
  bool isLoading = true;
  List<Widget> topHeader;
  List<Widget> currentAppointment;
  List<Widget> midHeader;
  List<Widget> futureAppointment;
  List<Widget> finalList;
  Firestore _firestore = Firestore.instance;
  AuthProvider _auth;
  SlidingCardController aController = new SlidingCardController();

  @override
  void initState() {
    super.initState();
    topHeader = [];
    currentAppointment = [];
    midHeader = [];
    futureAppointment = [];
    finalList = [];

    AppointmentManager.generateAppointmentList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (isFirstTime == false) {
      initiateList();
      isFirstTime = true;
    }
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: Text('My Appointments'),
        ),
        body: Container(
            child: AnimationLimiter(
                child: StreamBuilder(
                    stream: _firestore
                        .collection('bookings')
                        .where('customerUid', isEqualTo: _auth.currentUser.id.toString())
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Container(child: Text("No appointments")));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          developer.log(snapshot.data.documents[index].toString());
                          var app = Appointment(
                              date: snapshot.data.documents[index]['date'],
                              myId: snapshot.data.documents[index]['stylist'],
                              customerName: snapshot.data.documents[index]['customerName'],
                              phoneNumber: snapshot.data.documents[index]['phoneNumber'],
                              status: snapshot.data.documents[index]['status']);
                          developer.log(app.customerName);
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: 375),
                            child: SlideAnimation(
                                verticalOffset: -20,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: MiniAppointmentCard(
                                    onCardTapped: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: AppointmentDetailScreen(
                                                appointmentData: app,
                                              )));
                                    },
                                    key: Key(Random().nextInt(4000).toString()),
                                    appointmentData: app,
                                  ),
                                )),
                          );
                        },
                      );
                    }))));
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
            'Dr. @emilecode',
            style: TextStyle(
              fontSize: SizeConfig.horizontalBloc * 9.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );

    //now we create the card comming from the appointment manager
    for (var anElement in AppointmentManager.appointmentList) {
      if (anElement.isFuture == false) {
        ///not obliged to be this way , can directly be passed at time of initialization

        print('adding big card');
        currentAppointment.add(Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: AppointmentCard(
            onCardTapped: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: AppointmentDetailScreen(
                        appointmentData: anElement,
                      )));
            },
            key: Key(Random().nextInt(4000).toString()),
            slidingCardController: aController,
            appointmentData: anElement,
          ),
        )));
      } else {
        print('adding mini card');
        futureAppointment.add(Center(
            child: MiniAppointmentCard(
          onCardTapped: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: AppointmentDetailScreen(
                      appointmentData: anElement,
                    )));
          },
          appointmentData: anElement,
        )));
      }
    }
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
    finalList.addAll(futureAppointment);
    if (isFirstTime == false) {
      isLoading = false;
      setState(() {});
    }
    setState(() {});
    return true;
  }
}
