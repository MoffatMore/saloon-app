import 'dart:io';

import 'package:cssalonapp/Model/Validation.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/theme/CustomStyle.dart';
import 'package:cssalonapp/widgets/BackGroundImage.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:cssalonapp/widgets/CustomTextFormField.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  Validation validation = Validation();
  bool isAutoSubmit = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode email;
  FocusNode password;
  FocusNode username;
  FocusNode surname;
  FocusNode phone;
  FocusNode description;
  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  TextEditingController usernameCtrl;
  TextEditingController surnameCtrl;
  TextEditingController phoneCtrl;
  TextEditingController descriptionCtrl;
  AuthProvider _provider;
  bool submitted;
  String mode;
  String profession;
  Future<File> imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    email = FocusNode();
    password = FocusNode();
    description = FocusNode();
    username = FocusNode();
    surname = FocusNode();
    phone = FocusNode();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    usernameCtrl = TextEditingController();
    surnameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    descriptionCtrl = TextEditingController();
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
    super.dispose();
  }

  unFocus() {
    email.unfocus();
    password.unfocus();
    username.unfocus();
    surname.unfocus();
    phone.unfocus();
    description.unfocus();
  }

  saveProfile(BuildContext context) async {
    setState(() => submitted = true);
    File file = await imageFile;
    _provider.updateUser(usernameCtrl.text, phoneCtrl.text, surnameCtrl.text, emailCtrl.text,
        passwordCtrl.text, profession, descriptionCtrl.text, file);
    Navigator.pop(context);
  }

  //Open gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Stack(
        children: <Widget>[
          BackGroundImage(
            image: "assets/images/home/makeUp.jpg",
          ),
          SafeArea(
              child: Form(
            autovalidate: isAutoSubmit,
            key: _formKey,
            child: SingleChildScrollView(
              child: FutureBuilder<FirebaseUser>(
                  future: _auth.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      emailCtrl.text = snapshot.data.email;
                      usernameCtrl.text = _provider.currentUser.username;
                      surnameCtrl.text = _provider.currentUser.surname;
                      phoneCtrl.text = _provider.currentUser.phone;
                      descriptionCtrl.text = _provider.currentUser.description;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                                ? MediaQuery.of(context).size.height / 130
                                : 0,
                          ),
                          SizedBox(height: 0.0),
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
                              validator: (value) => validation.validate("Phone", value, TYPE.TEXT),
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
                              validator: (value) => validation.validate("Email", value, TYPE.EMAIL),
                              hintText: "Email",
                              onSubmitted: (value) {
                                email.unfocus();
                                FocusScope.of(context).requestFocus(password);
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 10.0),
                          Visibility(
                            visible: _provider.currentUser.mode != null &&
                                _provider.currentUser.mode == 'Stylist',
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              color: Colors.white,
                              child: DropDownFormField(
                                titleText: 'Stylist Speciality',
                                hintText: 'Please choose one',
                                value: profession ?? _provider.currentUser.profession,
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
                                  {'display': 'Hair Care', 'value': 'Hair Care'},
                                  {'display': 'Make Up Artist', 'value': 'Make Up'},
                                  {'display': 'Bridal', 'value': 'Bridal'},
                                  {'display': 'Nail Technician', 'value': 'Nail Technician'},
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _provider.currentUser.mode != null &&
                                _provider.currentUser.mode == 'Stylist',
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: descriptionCtrl,
                                    focusNode: description,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.0),
                                      hintText: "Job Description",
                                      fillColor: Colors.white,
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomTextFormField(
                              isPassword: true,
                              textInputAction: TextInputAction.next,
                              controller: passwordCtrl,
                              focusNode: password,
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
                          SizedBox(height: 10.0),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Button(
                                  color: primaryColor,
                                  width: double.infinity,
                                  name: "Save",
                                  onTap: () {
                                    saveProfile(context);
                                  },
                                  textStyle: loginButton,
                                  loader: submitted
                                      ? CupertinoActivityIndicator(
                                          animating: true,
                                          radius: 10,
                                        )
                                      : null)),
                        ],
                      );
                    }
                    return Center(
                        child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          CupertinoActivityIndicator(),
                          Text("loading profile...")
                        ],
                      ),
                    ));
                  }),
            ),
          ))
        ],
      ),
    );
  }
}
