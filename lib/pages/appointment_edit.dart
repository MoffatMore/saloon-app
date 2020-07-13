import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/pages/appointments.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/widgets/ActionButton.dart';
import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:quick_feedback/quick_feedback.dart';

class AppointmentEditScreen extends StatefulWidget {
  final Appointment appointmentData;
  const AppointmentEditScreen({Key key, @required this.appointmentData})
      : super(key: key);
  @override
  _AppointmentEditScreenState createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends State<AppointmentEditScreen>
    with SingleTickerProviderStateMixin {
  bool isContainerCollapsed = true;
  bool isDateAndTimeVisible = false;
  bool isUserProfileImageVisible = false;
  bool isPhoneLogoVisible = false;
  bool areDetailsvisible = false;
  AnimationController animationController;
  Tween<double> tweenedValue;
  Animation tweenAnimation;
  AuthProvider _provider;
  DateTime selectedDate;
  bool isLoading = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<AuthProvider>(context);
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: reverseAnimation,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: Duration(milliseconds: 230),
        opacity: isContainerCollapsed ? 0 : 1,
        child: ActionButton(
          value1: widget.appointmentData?.status == 'declined'
              ? "Re-schedule"
              : "Edit",
          value2: "Delete",
          visible: widget.appointmentData?.status == 'pending',
          isLoading: isLoading,
          onAcceptPressed: () => openDatePicker(context),
          onDecinePressed: () async {
            await Bookings.deleteBooking(widget.appointmentData.docId);
            reverseAnimation();
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  AnimatedContainer(
                    curve: isContainerCollapsed
                        ? Curves.elasticIn
                        : Curves.elasticOut,
                    duration: Duration(seconds: 1),
                    height: isContainerCollapsed
                        ? 0
                        : SizeConfig.safeBlockVertical * 30,
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
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Container(
                              //color: Colors.white,
                              width: SizeConfig.safeBlockHorizontal * 80,
                              child: Center(
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 375),
                                  opacity: isDateAndTimeVisible ? 1 : 0,
                                  child: Text(
                                    'Time period \n Date ${(widget.appointmentData?.date)}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65.0, top: 4, right: 22),
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
                              "Stylist: ${widget.appointmentData.myId}",
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
                                "Status: ${widget.appointmentData.status ?? 'Pending'}",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 8,
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
                                'Stylist Reply Message:',
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
                              widget.appointmentData?.status == 're-schedule'
                                  ? "Available slot \n" +
                                      widget.appointmentData?.reSchedule +
                                      ' '
                                          '\n ${widget.appointmentData.comment}'
                                  : 'No Comments',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 4.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.appointmentData?.review != null &&
                              widget.appointmentData?.review == 'requested',
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20),
                              Container(
                                  //color: Colors.yellow,
                                  width: SizeConfig.safeBlockHorizontal * 80,
                                  height: SizeConfig.safeBlockVertical * 4,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Customer review requested!',
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  4.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black45),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 40,
                                  width: SizeConfig.safeBlockHorizontal * 70,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: FlatButton(
                                    child: isLoading
                                        ? Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : Text(
                                            "Rate Stylist",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                    onPressed: () => _showFeedback(context),
                                  ),
                                ),
                              )
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

  void _showFeedback(context) {
    showDialog(
      context: context,
      builder: (context) {
        return QuickFeedback(
          title: 'Leave a feedback', // Title of dialog
          showTextBox: true, // default false
          textBoxHint:
              'Share your feedback', // Feedback text field hint text default: Tell us more
          submitText: 'SUBMIT', // submit button text default: SUBMIT
          onSubmitCallback: (feedback) {
            Bookings.rateBooking(feedback, widget.appointmentData.myId,
                widget.appointmentData.docId);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AppointmentScreen()));
          },
          askLaterText: 'ASK LATER',
          onAskLaterCallback: () {
            print('Do something on ask later click');
          },
        );
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
      Map<String, dynamic> data = {'date': date.toString()};
      await Bookings.editBooking(data, widget.appointmentData.docId);
      setState(() {
        isLoading = false;
      });
      print('confirm $date');
    }, locale: LocaleType.en);
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
