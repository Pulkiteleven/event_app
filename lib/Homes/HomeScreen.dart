import 'package:event_app/AlooDart.dart';
import 'package:event_app/NavDrawer/NavDrawer.dart';
import 'package:event_app/QR/UserQR.dart';
import 'package:event_app/Usefull/Functions.dart';
import 'package:event_app/screens/MyFeeds.dart';
import 'package:event_app/screens/Profile.dart';
import 'package:event_app/screens/allEvents.dart';
import 'package:event_app/screens/home.dart';
import 'package:event_app/screens/post.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Usefull/Colors.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';



final GlobalKey<ScaffoldState> _key = GlobalKey();

late _homeScreenState stateofHomeScreen;

class homeScreen extends StatefulWidget {
  Map data;
  homeScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<homeScreen> createState() {
    stateofHomeScreen = _homeScreenState();
    return stateofHomeScreen;
  }
}

class _homeScreenState extends State<homeScreen> {
  bool isHide = false;
  int _index = 0;
  List bottomItems = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // testApi();
    setState(() {
      bottomItems = [
        Home(data: widget.data,),
        allEvents(data: widget.data),
        myFeeds(data: widget.data),
        userProfile(data: widget.data)
       // profile(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: bgColor,
      drawer: navigationDrawer(allData: widget.data,),
      appBar: AppBar(
        backgroundColor: transparent_overlay,
        elevation: 0.0,

        leading: Row(
          children: [
            SizedBox(),
            IconButton(
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
                icon: Icon(Iconsax.menu_1))
          ],
        ),
        centerTitle: true,
        title: Row(
          children: [
            // Icon(Iconsax.car),
            // Spacer(),
            mainText("ibento", textColor, 15.0, FontWeight.bold, 1),
            Spacer(),

          ],
        ),
        actions: [
          IconButton(onPressed: () {
            navScreen( PostScreen(), context, false);
          }, icon: Icon(Iconsax.add_circle)),

          IconButton(onPressed: () {
            navScreen(userQR(text: "Attendance QR", qrs: "${widget.data['uid']}&${widget.data['name']}&${widget.data['index']}", data: widget.data), context, false);
          }, icon: Icon(Iconsax.scan_barcode))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
        child: CustomNavigationBar(
          borderRadius: Radius.circular(10.0),
          elevation: 10.0,
          isFloating: true,
          currentIndex: _index,
          backgroundColor: mainColor,
          unSelectedColor: bgColor,
          selectedColor: Colors.white,
          iconSize: 25.0,
          onTap: (i) {
            setState(() {
              _index = i;

              if (_index == 2) {
                isHide = true;
              }
            });
          },
          items: [
            CustomNavigationBarItem(
                icon: Icon(
                  Iconsax.home,
                ),),
                // title:
                //     mainText("Home", Colors.white, 10.0, FontWeight.normal, 1)),
            CustomNavigationBarItem(
                icon: Icon(
                  Iconsax.dcube,
                ),),
                // title: mainText(
                //     "Children", Colors.white, 10.0, FontWeight.normal, 1)),
            CustomNavigationBarItem(
                icon: Icon(
                  Iconsax.ghost,
                ),),
                // title:
                //     mainText("Post", Colors.white, 10.0, FontWeight.normal, 1)),
            CustomNavigationBarItem(
                icon: Icon(
                  Iconsax.user,
                ),),
                // title: mainText(
                //     "Profile", Colors.white, 10.0, FontWeight.normal, 1)),
          ],
        ),
      ),
      body: Stack(children: [
        circles(context),
        bottomItems.elementAt(_index)]),
    );
  }
}
