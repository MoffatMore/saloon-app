import 'package:cssalonapp/pages/Home.dart';
import 'package:cssalonapp/pages/Login.dart';
import 'package:cssalonapp/pages/Signup.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RootState();
  }
}

class RootState extends State<Root> {
  AuthProvider _auth;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = _auth.currentUser;

    switch (_auth.state) {
      case AuthState.SIGNEDIN:
        if (_currentUser.admin) return Home();
        return Home();
      case AuthState.SIGNEDOUT:
        return Login();
      case AuthState.LOADING:
        return LoadingScreen();
      default:
        if (_currentUser != null) {
          return Home();
        }
        return Signup();
    }
  }
}
