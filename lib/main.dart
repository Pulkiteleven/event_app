import 'package:event_app/Backend/backend.dart';
import 'package:event_app/Homes/HomeScreen.dart';

import 'package:event_app/NavDrawer/NavDrawer.dart';
import 'package:event_app/NavDrawer/nav_screen/about_us.dart';

import 'package:event_app/Usefull/Colors.dart';
import 'package:event_app/Usefull/Functions.dart';
import 'package:event_app/screens/home.dart';
import 'package:event_app/screens/post.dart';
import 'package:event_app/Auth/sign_in.dart';
import 'package:event_app/Auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:event_app/Usefull/Colors.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    // home:homeScreen(data: {},)
    theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.cyan),

    // home:logIn(),
    home: Splash()
    // home: signUp()
    // home: signUp()




  ));
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      check();
    });

  }

  check() async {
    if (_auth.currentUser != null) {
      checker(context);
    } else {
      navScreen(logIn(), context, true);

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mainColor,
        body: Stack(
          children: [
            coolcircles(context),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Spacer(),
                    mainText("ibento", textColor, 40.0, FontWeight.bold, 1),
                    Spacer(),
                  ],
                ),
                mainText("ASPER", bgLight, 10.0, FontWeight.normal, 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
