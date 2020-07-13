import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/pages/custom-action.dart';
import 'package:cssalonapp/pages/re-schedule.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointmentData;
  const AppointmentDetailScreen({Key key, @required this.appointmentData})
      : super(key: key);
  @override
  _AppointmentDetailScreenState createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isContainerCollapsed = true;
  bool isDateAndTimeVisible = false;
  bool isUserProfileImageVisible = false;
  bool isPhoneLogoVisible = false;
  bool areDetailsvisible = false;
  AnimationController animationController;
  Tween<double> tweenedValue;
  Animation tweenAnimation;
  bool isLoading = false;
  DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    initiateAnimation();
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 275),
    );
    tweenedValue = Tween(begin: 50, end: 0);
    tweenAnimation = tweenedValue.animate(animationController);
    animationController.addListener(
      () {
        setState(() {});
      },
    );
  }

  ///The animation here are staged
  void initiateAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isContainerCollapsed = false;
      });
    }).then(
      (f) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            isDateAndTimeVisible = true;
          });
        }).then((f) {
          Future.delayed(Duration(milliseconds: 200), () {
            setState(() {
              isUserProfileImageVisible = true;
            });
          }).then((f) {
            Future.delayed(Duration(milliseconds: 200), () {
              setState(() {
                isPhoneLogoVisible = true;
              });
            }).then((f) {
              Future.delayed(Duration(milliseconds: 150), () {
                setState(() {
                  areDetailsvisible = true;
                });
                animationController.forward();
              });
            });
          });
        });
      },
    );
  }

  openDatePicker(BuildContext context) async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(new Duration(days: 365)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) async {
      setState(() {
        isLoading = true;
        selectedDate = date;
      });
      Map<String, dynamic> data = {
        'schedule-date': date.toString(),
        'status': 'declined'
      };
      await Bookings.editBooking(data, widget.appointmentData.docId);
      setState(() {
        isLoading = false;
      });
      reverseAnimation();
      print('confirm $date');
    }, locale: LocaleType.en);
  }

  acceptBooking() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {"status": "accepted"};
    Bookings.editBooking(data, widget.appointmentData.docId);
    reverseAnimation();
  }

  void declineAppointment(Appointment appointmentData) async {
    Map<String, dynamic> data = {'status': 'declined'};
    setState(() {
      isLoading = true;
    });
    await Bookings.editBooking(data, appointmentData.docId);
    reverseAnimation();
  }

  sendReview() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = {"review": "requested"};
    Bookings.editBooking(data, widget.appointmentData.docId);
    reverseAnimation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: AnimatedOpacity(
        duration: Duration(milliseconds: 230),
        opacity: isContainerCollapsed ? 0 : 1,
        child: CustomActionButton(
          visible: widget.appointmentData?.review == null,
          isLoading: isLoading,
          value1: widget.appointmentData.status == 'accepted'
              ? 'review link'
              : 'accept',
          value2: "Cancel",
          onAcceptPressed: () => widget.appointmentData.status == 'accepted'
              ? sendReview()
              : acceptBooking(),
          onDecinePressed: () {
            declineAppointment(widget.appointmentData);
          },
          onReschedulePressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReBooking(
                          title: "Schedule",
                          app: widget.appointmentData,
                        )));
            reverseAnimation();
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AnimatedContainer(
                    curve: isContainerCollapsed
                        ? Curves.elasticIn
                        : Curves.elasticOut,
                    duration: Duration(seconds: 1),
                    height: isContainerCollapsed
                        ? 0
                        : SizeConfig.safeBlockVertical * 40,
                    width: isContainerCollapsed
                        ? 0
                        : SizeConfig.safeBlockHorizontal * 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(145),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 48.0),
                          child: Container(
                            //color: Colors.white,
                            height: SizeConfig.safeBlockVertical * 19,
                            width: SizeConfig.safeBlockHorizontal * 80,
                            child: Center(
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 375),
                                opacity: isDateAndTimeVisible ? 1 : 0,
                                child: Text(
                                  'Time period \n Date ${(widget.appointmentData?.date)}',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 45,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: Row(
                        children: <Widget>[
//                          Align(
//                            alignment: Alignment.bottomLeft,
//                            child: AnimatedOpacity(
//                              opacity: isUserProfileImageVisible ? 1 : 0,
//                              duration: Duration(milliseconds: 300),
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  image: DecorationImage(
//                                      image: CachedNetworkImageProvider(
//                                          widget.appointmentData.imgLink),
//                                      fit: BoxFit.fill),
//                                  color: Colors.grey[200],
//                                  border: Border.all(color: Colors.white, width: 5),
//                                  borderRadius: BorderRadius.circular(35),
//                                ),
//                                height: SizeConfig.safeBlockVertical * 13,
//                                width: SizeConfig.safeBlockHorizontal * 26,
//                              ),
//                            ),
//                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 18),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () {
                                  print('call button pressed');
                                },
                                child: AnimatedOpacity(
                                  opacity: isPhoneLogoVisible ? 1 : 0,
                                  duration: Duration(milliseconds: 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                    height: SizeConfig.safeBlockVertical * 8.66,
                                    width:
                                        SizeConfig.safeBlockHorizontal * 17.33,
                                    child: Icon(
                                      Icons.access_alarm,
                                      size:
                                          SizeConfig.safeBlockHorizontal * 8.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65.0, top: 8, right: 22),
                child: Transform.translate(
                  offset: Offset(0, tweenAnimation.value),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 235),
                    opacity: areDetailsvisible ? 1 : 0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockHorizontal * 80,
                          height: SizeConfig.safeBlockVertical * 9,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.appointmentData.customerName,
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                            //color: Colors.yellow,
                            width: SizeConfig.safeBlockHorizontal * 80,
                            height: SizeConfig.safeBlockVertical * 9,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.appointmentData.status ?? 'Pending',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                        Container(
                            //color: Colors.yellow,
                            width: SizeConfig.safeBlockHorizontal * 80,
                            height: SizeConfig.safeBlockVertical * 4,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.appointmentData?.reSchedule != null
                                    ? "Available slot"
                                    : 'Comment',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45),
                              ),
                            )),
                        Container(
                          //color: Colors.yellow,
                          width: SizeConfig.safeBlockHorizontal * 80,
                          //height: SizeConfig.safeBlockVertical*20,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.appointmentData?.reSchedule ??
                                  'No comments',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 4.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.appointmentData?.review != null,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Container(
                                  //color: Colors.yellow,
                                  width: SizeConfig.safeBlockHorizontal * 80,
                                  height: SizeConfig.safeBlockVertical * 4,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Customer Review',
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  4.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black45),
                                    ),
                                  )),
                              Container(
                                //color: Colors.yellow,
                                width: SizeConfig.safeBlockHorizontal * 80,
                                //height: SizeConfig.safeBlockVertical*20,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.appointmentData?.review ??
                                        'No reviews',
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                4.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reverseAnimation() {
    Future.delayed(Duration(milliseconds: 00), () {
      setState(() {
        isContainerCollapsed = true;
      });
    }).then((f) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isDateAndTimeVisible = false;
        });
      }).then((f) {
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            isUserProfileImageVisible = false;
          });
        }).then((f) {
          Future.delayed(Duration(milliseconds: 200), () {
            setState(() {
              isPhoneLogoVisible = false;
            });
          }).then((f) {
            Future.delayed(Duration(milliseconds: 250), () {
              setState(() {
                areDetailsvisible = false;
              });
              animationController.reverse().then((f) {
                Navigator.pop(context);
              });
            });
          });
        });
      });
    });
  }
}
