import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Model/user.dart';

/// App has three states
/// [SIGNEDIN] : [AuthProvider.currentUser] != null and has full acesss
///  [SIGNEDOUT] : [AuthProvider.currentUser] = null and limited acess
///  [ LOADING ] : App is waiting for process, loading screen displayed
enum AuthState { SIGNEDIN, SIGNEDOUT, LOADING }

class AuthProvider with ChangeNotifier {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// state of the entire app
  AuthState _state = AuthState.SIGNEDOUT;
  AuthState get state => _state;
  set state(value) {
    _state = value;
    notifyListeners();
  }

  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// user logged into the app
  User _currentUser;

  User get currentUser => _currentUser;

  /// fetch user data stored in the cloud db
  Future<User> _setCurrentUser(FirebaseUser user) async {
    var reference = Firestore.instance.collection("profile").document(user.uid);
    var _snapshot = await reference.get();
    return User.fromMap(_snapshot.data);
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = AuthState.LOADING;
    // magic internet tricks
    email = email.trim();
    try {
      // sign in with firebase
      AuthResult _result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(_result.user);

      // fetch user info from database
      FirebaseUser _user = _result.user;
      currentUser = await _setCurrentUser(_user);
      // notify ui
      state = AuthState.SIGNEDIN;
    } on PlatformException catch (e) {
      print(e.message);
      state = AuthState.SIGNEDOUT;
    }
  }

  Future<void> signIn() async {
    // set state to loading
    _state = AuthState.LOADING;
    notifyListeners();
  }

  Future<void> createUser(
      String username, String phone, String lastname, String email, String password) async {
    signIn();
    try {
      email = email.trim();
      AuthResult _result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_result.user != null) {
        var user = _result.user;
        Firestore.instance
            .collection("profile")
            .document(user.uid)
            .setData({"username": username, "surname": lastname, "phone": phone, "id": user.uid})
        .then((value) => signOut());
        
      } else {
        log('couldn\'t register user');
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    _state = AuthState.SIGNEDOUT;
    log('successfully registered user');
    notifyListeners();
  }
}
