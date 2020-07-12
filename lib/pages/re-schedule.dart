import 'package:cssalonapp/Model/Validation.dart';
import 'package:cssalonapp/Model/appointment.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:cssalonapp/widgets/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class ReBooking extends StatefulWidget {
  String title;
  Appointment app;

  ReBooking({this.title, this.app});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookingState();
  }
}

class BookingState extends State<ReBooking> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode comment;
  TextEditingController commentCtrl;
  String _chosen = '';
  DateTime selectedDate;
  bool isLoading = false;
  Validation validation = Validation();
  openDatePicker(BuildContext context) async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(new Duration(days: 365)), onChanged: (date) {
      print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        selectedDate = date;
      });
      print('confirm $date');
    }, locale: LocaleType.en);
  }

  @override
  void initState() {
    super.initState();
    comment = FocusNode();
    commentCtrl = TextEditingController();
  }

  onSubmit() {
    if (_formKey.currentState.validate()) {
      unFocus();
      setState(() {
        isLoading = true;
      });

      Bookings.schedule(
          comment: commentCtrl.text, date: selectedDate?.toString(), docID: widget.app.docId);
      setState(() {
        isLoading = false;
      });
      Toast.show("Successfully re-scheduled an appointment", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.pop(context);
    }
  }

  unFocus() {
    comment.unfocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    unFocus();
    commentCtrl?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text("${widget.title} Booking"),
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
                        ),
                        Text(
                          "Appointment Schedule Form",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        CustomTextFormField(
                          focusNode: comment,
                          validator: (val) => validation.validate("Username", val, TYPE.TEXT),
                          controller: commentCtrl,
                          hintText: "Comment",
                          onSubmitted: (val) {
                            comment.unfocus();
                          },
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            openDatePicker(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              color: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              child: Text((selectedDate != null)
                                  ? selectedDate.toLocal().toString()
                                  : "Select Date"),
                            ),
                          ),
                        ),
                        (selectedDate == null)
                            ? Container(
                                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Please select date",
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 20.0,
                        ),
                        CustomButton(
                          width: double.infinity,
                          color: primaryColor,
                          onTap: () {
                            unFocus();
                            onSubmit();
                          },
                          textStyle: TextStyle(color: Colors.white),
                          name: "Submit",
                        )
                      ],
                    ),
                  )),
            )
          ],
        ));
  }

  String getDate(DateTime time) {
    double _time = double.parse("${time.hour}.${time.minute}");
    return "${time.day}/${time.month}/${time.year} ${_time}  ${time.weekday}";
  }
}
