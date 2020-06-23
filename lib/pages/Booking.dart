import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cssalonapp/Model/Validation.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/providers/bookings.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:cssalonapp/widgets/CustomTextFormField.dart';
import 'package:cssalonapp/widgets/loading_screen.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Booking extends StatefulWidget {
  String title;

  Booking({this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookingState();
  }
}

class BookingState extends State<Booking> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode username;
  FocusNode stylist;
  FocusNode phoneNumber;
  TextEditingController stylistCtrl;
  TextEditingController phoneCtrl;
  String _chosen = '';
  bool isAutoValid = false;
  DateTime selectedDate;
  Validation validation = Validation();
  AuthProvider _auth;
  bool isLoading = false;

  openDatePciekr(BuildContext context) async {
    DateTime pickeed = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickeed != null) {
      setState(() {
        selectedDate = pickeed;
      });
    }
    print(pickeed);
  }

  @override
  void initState() {
    super.initState();
    stylist = FocusNode();
    phoneNumber = FocusNode();
    username = FocusNode();
    stylistCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
  }

  onSubmit() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Bookings.book(
          customerName: _auth.currentUser.username.toString(),
          customerPhone: phoneCtrl.text,
          customerUid: _auth.currentUser.id.toString(),
          date: selectedDate?.toString()?.split(' ')[0],
          stylist: _chosen,
          reason: widget.title);
      setState(() {
        isLoading = false;
      });
      Toast.show("Successfully booked for appointment", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  unFocus() {
    stylist.unfocus();
    stylist.unfocus();
    phoneNumber.unfocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    unFocus();
    stylist?.dispose();
    phoneNumber?.dispose();
    stylistCtrl?.dispose();
    phoneCtrl?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    phoneCtrl.text = _auth.currentUser.phone;
    stylistCtrl.text = _auth.currentUser.username;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text("${widget.title} Booking"),
        ),
      ),
      body: isLoading
          ? LoadingScreen()
          : Stack(
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
                              "Booking Form",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomTextFormField(
                              focusNode: username,
                              validator: (val) => validation.validate("Username", val, TYPE.TEXT),
                              controller: stylistCtrl,
                              hintText: "Username",
                              onSubmitted: (val) {
                                username.unfocus();
                                FocusScope.of(context).requestFocus(stylist);
                              },
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: Bookings.getHairCareStyList(widget.title),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      child: Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  }
                                  List hairCareStylist = List();
                                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                                    hairCareStylist.add({
                                      'display': snapshot.data.documents[i]['username'],
                                      'value': snapshot.data.documents[i]['username'],
                                    });
                                  }
                                  return Container(
                                    color: Colors.white,
                                    child: DropDownFormField(
                                      titleText: 'My ${widget.title} stylist',
                                      hintText: 'Please choose one',
                                      value: _chosen,
                                      onSaved: (value) {
                                        setState(() {
                                          _chosen = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _chosen = value;
                                        });
                                      },
                                      textField: 'display',
                                      valueField: 'value',
                                      required: true,
                                      dataSource: hairCareStylist,
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 10.0,
                            ),
                            CustomTextFormField(
                              onSubmitted: (val) {
                                phoneNumber.unfocus();
                              },
                              validator: (val) =>
                                  validation.validate("Phone number", val, TYPE.TEXT),
                              focusNode: phoneNumber,
                              controller: phoneCtrl,
                              hintText: "Contact no",
                              textInputType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                openDatePciekr(context);
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
                                      ? getDate(selectedDate)
                                      : "Select Date"),
                                ),
                              ),
                            ),
                            (isAutoValid & (selectedDate == null))
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
            ),
    );
  }

  String getDate(DateTime time) {
    return "${time.day}/${time.month}/${time.year}";
  }
}
