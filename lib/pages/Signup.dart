import 'package:cssalonapp/Model/Validation.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:cssalonapp/theme/CustomStyle.dart';
import 'package:cssalonapp/widgets/BackGroundImage.dart';
import 'package:cssalonapp/widgets/CustomButton.dart';
import 'package:cssalonapp/widgets/CustomLogo.dart';
import 'package:cssalonapp/widgets/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  TextEditingController usernameCtrl;
  TextEditingController surnameCtrl;
  TextEditingController phoneCtrl;
  AuthProvider _provider;
  bool submitted;

  @override
  void initState() {
    super.initState();
    email = FocusNode();
    password = FocusNode();
    username = FocusNode();
    surname = FocusNode();
    phone = FocusNode();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    usernameCtrl = TextEditingController();
    surnameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
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
  }

  signup() async {
    setState(() => isAutoSubmit = true);
    if (_formKey.currentState.validate()) {
      _provider.createUser(
          usernameCtrl.text, phoneCtrl.text, surnameCtrl.text, emailCtrl.text, passwordCtrl.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.height / 50
                        : 0,
                  ),
                  CustomLogo(),
                  SizedBox(height: 30.0),
                  loginText(),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: usernameCtrl,
                      focusNode: username,
                      validator: (value) => validation.validate("Username", value, TYPE.TEXT),
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
                      validator: (value) => validation.validate("Surname", value, TYPE.TEXT),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextFormField(
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      controller: passwordCtrl,
                      focusNode: password,
                      validator: (value) => validation.validate("Password", value, TYPE.PASSWORD),
                      hintText: "Password",
                      onSubmitted: (value) {
                        password.unfocus();
                      },
                      textInputType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Button(
                          color: primaryColor,
                          width: double.infinity,
                          name: "Register Now",
                          onTap: () {
                            setState(() {
                              submitted = true;
                            });
                            unFocus();
                            signup();
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
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            style: TextStyle(fontSize: 23.0, color: Colors.white, fontWeight: FontWeight.bold),
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
