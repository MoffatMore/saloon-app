import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/src/asset.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../Model/user.dart';

/// App has three states
/// [SIGNEDIN] : [AuthProvider.currentUser] != null and has full acesss
///  [SIGNEDOUT] : [AuthProvider.currentUser] = null and limited acess
///  [ LOADING ] : App is waiting for process, loading screen displayed
enum AuthState { SIGNEDIN, SIGNEDOUT, LOADING }

class AuthProvider with ChangeNotifier {
  // firebase instance

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
      AuthResult _result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      String username,
      String phone,
      String lastname,
      String email,
      String password,
      String mode,
      String profession,
      String description,
      File image,
      String duration,
      String location,
      String workingHours) async {
    signIn();
    try {
      email = email.trim();
      AuthResult _result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_result.user != null) {
        var user = _result.user;
        if (mode == 'Customer') {
          Firestore.instance.collection("profile").document(user.uid).setData({
            "username": username,
            "surname": lastname,
            "phone": phone,
            "id": user.uid,
            'mode': mode,
          }).then((value) => signOut());
        } else {
          StorageReference storageReference = FirebaseStorage.instance
              .ref()
              .child('styles/${Path.basename(image.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(image);
          await uploadTask.onComplete;

          await storageReference.getDownloadURL().then((fileURL) {
            print('File Uploaded');
            Firestore.instance.collection('styles').add({
              'stylist': user.uid,
              'picture': fileURL,
              'duration': duration
            }).then((value) => {
                  print('style Uploaded'),
                  Firestore.instance
                      .collection("profile")
                      .document(user.uid)
                      .setData({
                    "username": username,
                    "surname": lastname,
                    "phone": phone,
                    "id": user.uid,
                    'mode': mode,
                    'profession': profession,
                    'description': description,
                    'location': location,
                    'working_hours': workingHours
                  }).then((value) => signOut())
                });
          });
        }
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

  Future uploadStyles(List<Asset> images, String duration) {
    images.forEach((image) async {
      File file = await writeToFile(await image.getByteData(), image.name);
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('styles/${Path.basename(file.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;

      return storageReference.getDownloadURL().then((fileURL) {
        print('File Uploaded');
        Firestore.instance.collection("styles").document().setData({
          "stylist": currentUser.id,
          'picture': fileURL,
          'duration': duration
        });
      });
    });
  }

  Future<File> writeToFile(ByteData data, String name) async {
    final buffer = data.buffer;
    final path = await _localPath;
    return new File('$path/$name').writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Stream<QuerySnapshot> getPics() {
    return Firestore.instance
        .collection("styles")
        .where("stylist", isEqualTo: currentUser.id)
        .snapshots();
  }

  Stream<DocumentSnapshot> getProfile() {
    return Firestore.instance
        .collection("profile")
        .document(currentUser.id)
        .snapshots();
  }

  Future<void> updateUser(
      String username,
      String phone,
      String lastname,
      String email,
      String password,
      String profession,
      String description,
      File image) async {
    try {
      email = email.trim();
      password = password.trim();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      AuthResult authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.getCredential(
          email: user.email,
          password: password,
        ),
      );
      if (authResult.user != null) {
        var user = authResult.user;
        if (currentUser.mode == 'Customer') {
          if (image != null) {
            StorageReference storageReference = FirebaseStorage.instance
                .ref()
                .child('styles/${Path.basename(image.path)}');
            StorageUploadTask uploadTask = storageReference.putFile(image);
            await uploadTask.onComplete;
            await storageReference.getDownloadURL().then((fileURL) {
              Firestore.instance
                  .collection("profile")
                  .document(user.uid)
                  .setData({
                "username": username,
                "surname": lastname,
                "phone": phone,
                "id": user.uid,
                'photo': fileURL
              });
            });
          } else {
            await Firestore.instance
                .collection("profile")
                .document(user.uid)
                .setData({
              "username": username,
              "surname": lastname,
              "phone": phone,
              "id": user.uid,
            });
          }
        } else {
          if (image != null) {
            StorageReference storageReference = FirebaseStorage.instance
                .ref()
                .child('styles/${Path.basename(image.path)}');
            StorageUploadTask uploadTask = storageReference.putFile(image);
            await uploadTask.onComplete;
            await storageReference.getDownloadURL().then((fileURL) {
              Firestore.instance
                  .collection("profile")
                  .document(user.uid)
                  .setData({
                "username": username,
                "surname": lastname,
                "phone": phone,
                "id": user.uid,
                'profession': profession,
                'description': description,
                'photo': fileURL
              });
            });
          } else {
            Firestore.instance
                .collection("profile")
                .document(user.uid)
                .setData({
              "username": username,
              "surname": lastname,
              "phone": phone,
              "id": user.uid,
              'profession': profession,
              'description': description,
            });
          }
        }
      } else {
        log('couldn\'t register user');
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
