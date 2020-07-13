import 'package:cssalonapp/pages/Home.dart';
import 'package:cssalonapp/pages/Login.dart';
import 'package:cssalonapp/pages/Root.dart';
import 'package:cssalonapp/pages/Signup.dart';
import 'package:cssalonapp/providers/auth.dart';
import 'package:cssalonapp/theme/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
        ],
        child: MaterialApp(
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => Home(),
            '/login': (BuildContext context) => Login(),
            '/signup': (BuildContext context) => Signup(),
            '/root': (BuildContext context) => Root(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "Raleway",
              primaryColor: primaryColor,
              accentColor: primaryColor),
          home: Root(),
        ));
  }
}
