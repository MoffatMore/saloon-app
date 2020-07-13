import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:cssalonapp/Model/Validation.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/theme/CustomStyle.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:cssalonapp/widgets/CustomLogo.dart';
import 'package:cssalonapp/widgets/CustomTextFormField.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  Validation validation = Validation();
  bool isAutoSubmit = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode email;
  FocusNode password;
  FocusNode username;
  FocusNode surname;
  FocusNode phone;
  FocusNode location;
  FocusNode description;
  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  TextEditingController usernameCtrl;
  TextEditingController surnameCtrl;
  TextEditingController phoneCtrl;
  TextEditingController descriptionCtrl;
  TextEditingController durationCtrl;
  TextEditingController locationCtrl;
  AuthProvider _provider;
  bool submitted;
  String mode;
  String profession;
  File imageFile;
  final picker = ImagePicker();
  bool isAutoValid = false;
  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    super.initState();
    email = FocusNode();
    password = FocusNode();
    description = FocusNode();
    username = FocusNode();
    surname = FocusNode();
    phone = FocusNode();
    location = FocusNode();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    usernameCtrl = TextEditingController();
    surnameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    descriptionCtrl = TextEditingController();
    durationCtrl = TextEditingController();
    locationCtrl = TextEditingController();
    submitted = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<AuthProvider>(context);
  }

  @override
  void dispose() {
    unFocus();
    email?.dispose();
    password?.dispose();
    username?.dispose();
    emailCtrl?.dispose();
    surname.dispose();
    phone.dispose();
    passwordCtrl?.dispose();
    usernameCtrl?.dispose();
    surnameCtrl?.dispose();
    phoneCtrl?.dispose();
    durationCtrl?.dispose();
    super.dispose();
  }

  unFocus() {
    email.unfocus();
    password.unfocus();
    username.unfocus();
    surname.unfocus();
    phone.unfocus();
    description.unfocus();
    location.unfocus();
  }

  openStartDatePicker(BuildContext context) async {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        startDate = date;
      });
      print('confirm $date');
    }, locale: LocaleType.en);
  }

  openEndDatePicker(BuildContext context) async {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      setState(() {
        endDate = date;
      });
      print('confirm $date');
    }, locale: LocaleType.en);
  }

  String getDate(DateTime time) {
    double _time = double.parse("${time.hour}.${time.minute}");
    return "${time.day}/${time.month}/${time.year} ${_time}  ${time.weekday}";
  }

  signup(BuildContext context) async {
    setState(() => isAutoSubmit = true);
    if (_formKey.currentState.validate()) {
      if (imageFile == null && mode == 'Stylist') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Image empty",
          text: "You must specify any picture of your works",
        );
        setState(() => submitted = false);
      } else if (mode == null) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "User Mode Empty",
          text: "You must specify user mode first",
        );
      } else if (mode == null) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "User Mode Empty",
          text: "You must specify user mode first",
        );
      } else if (durationCtrl.text == '' && mode == 'Stylist') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Duration empty",
          text: "You must specify duration first",
        );
      } else {
        setState(() => submitted = true);
        File file = await imageFile;
        String hours = startDate.toString() + ' to ' + endDate.toString();
        _provider.createUser(
            usernameCtrl.text,
            phoneCtrl.text,
            surnameCtrl.text,
            emailCtrl.text,
            passwordCtrl.text,
            mode,
            profession,
            descriptionCtrl.text,
            file,
            durationCtrl.text,
            locationCtrl.text,
            hours);
        Navigator.pop(context);
      }
    }
  }

  //Open gallery
  pickImageFromGallery(ImageSource source) async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image.path);
    });
  }

  Widget showImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile,
        width: 300,
        height: 200,
      );
    } else if (imageFile != null) {
      return const Text(
        'Error Picking Image',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'No Image Selected',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SafeArea(
              child: Form(
            autovalidate: isAutoSubmit,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? MediaQuery.of(context).size.height / 130
                        : 0,
                  ),
                  CustomLogo(),
                  SizedBox(height: 0.0),
                  loginText(),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: usernameCtrl,
                      focusNode: username,
                      validator: (value) =>
                          validation.validate("Username", value, TYPE.TEXT),
                      hintText: "Username",
                      onSubmitted: (value) {
                        username.unfocus();
                        FocusScope.of(context).requestFocus(username);
                      },
                      textInputType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: surnameCtrl,
                      focusNode: surname,
                      validator: (value) =>
                          validation.validate("Surname", value, TYPE.TEXT),
                      hintText: "Surname",
                      onSubmitted: (value) {
                        surname.unfocus();
                        FocusScope.of(context).requestFocus(surname);
                      },
                      textInputType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: phoneCtrl,
                      focusNode: phone,
                      validator: (value) =>
                          validation.validate("Phone", value, TYPE.TEXT),
                      hintText: "Contact +267",
                      onSubmitted: (value) {
                        phone.unfocus();
                        FocusScope.of(context).requestFocus(phone);
                      },
                      textInputType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: emailCtrl,
                      focusNode: email,
                      validator: (value) =>
                          validation.validate("Email", value, TYPE.EMAIL),
                      hintText: "Email",
                      onSubmitted: (value) {
                        email.unfocus();
                        FocusScope.of(context).requestFocus(password);
                      },
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    color: Colors.white,
                    child: DropDownFormField(
                      titleText: 'Sign up mode',
                      hintText: 'Please choose one',
                      value: mode,
                      onSaved: (value) {
                        setState(() {
                          mode = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          mode = value;
                        });
                      },
                      textField: 'display',
                      valueField: 'value',
                      required: true,
                      dataSource: [
                        {'display': 'Customer', 'value': 'Customer'},
                        {'display': 'Stylist', 'value': 'Stylist'},
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.white,
                      child: DropDownFormField(
                        titleText: 'Stylist Speciality',
                        hintText: 'Please choose one',
                        value: profession,
                        onSaved: (value) {
                          setState(() {
                            profession = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            profession = value;
                          });
                        },
                        textField: 'display',
                        valueField: 'value',
                        required: true,
                        dataSource: [
                          {'display': 'Braids', 'value': 'Braids'},
                          {'display': 'Weaves', 'value': 'Weaves'},
                          {'display': 'Cornrows', 'value': 'Cornrows'},
                          {'display': 'Crotchet', 'value': 'Crotchet'},
                          {'display': 'Dreads', 'value': 'Dreads'},
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.newline,
                            controller: descriptionCtrl,
                            focusNode: description,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),
                              hintText: "Job Description",
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              enabledBorder: formOutlineBorder,
                              border: formOutlineBorder,
                              focusedBorder: formOutlineBorder,
                            ),
                            maxLines: 3,
                            onSaved: (value) {
                              description.unfocus();
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: GestureDetector(
                        onTap: () {
                          openStartDatePicker(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              padding: EdgeInsets.all(10.0),
                              child: Text((startDate != null)
                                  ? startDate.toLocal().toString()
                                  : "Available From Time"),
                            ),
                          ),
                        )),
                  ),
                  Visibility(
                      visible: mode != null && mode == 'Stylist',
                      child: (isAutoValid & (startDate == null))
                          ? Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Please select Available from time",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ))
                          : Container()),
                  SizedBox(height: 10.0),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: GestureDetector(
                        onTap: () {
                          openEndDatePicker(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              padding: EdgeInsets.all(10.0),
                              child: Text((endDate != null)
                                  ? endDate.toLocal().toString()
                                  : "Available To Time"),
                            ),
                          ),
                        )),
                  ),
                  Visibility(
                      visible: mode != null && mode == 'Stylist',
                      child: (isAutoValid & (startDate == null))
                          ? Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Please select Available time",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ))
                          : Container()),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: locationCtrl,
                            focusNode: location,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),
                              hintText: "Location",
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              enabledBorder: formOutlineBorder,
                              border: formOutlineBorder,
                              focusedBorder: formOutlineBorder,
                            ),
                            onSaved: (value) {
                              location.unfocus();
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      controller: passwordCtrl,
                      focusNode: password,
                      validator: (value) =>
                          validation.validate("Password", value, TYPE.PASSWORD),
                      hintText: "Password",
                      onSubmitted: (value) {
                        password.unfocus();
                      },
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Visibility(
                    visible: mode != null && mode == 'Stylist',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        showImage(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Select Image from Gallery"),
                                  onPressed: () {
                                    pickImageFromGallery(ImageSource.gallery);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: imageFile != null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomTextFormField(
                        textInputAction: TextInputAction.next,
                        controller: durationCtrl,
                        validator: (value) =>
                            validation.validate("duration", value, TYPE.TEXT),
                        hintText: "Duration (Hrs&mins)",
                        onSubmitted: (value) {},
                        textInputType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Button(
                          color: primaryColor,
                          width: double.infinity,
                          name: "Register Now",
                          onTap: () {
                            unFocus();
                            signup(context);
                          },
                          textStyle: loginButton,
                          loader: submitted
                              ? CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 10,
                                )
                              : null)),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account ? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login here",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget loginText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 4.5,
            height: 2.0,
            color: primaryColor,
          ),
          Text(
            "Register now",
            style: TextStyle(
                fontSize: 23.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 4.5,
            height: 2.0,
            color: primaryColor,
          )
        ],
      ),
    );
  }
}
