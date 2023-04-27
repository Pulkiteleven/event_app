import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:event_app/Backend/backend.dart';
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Event/OneEvent.dart';
import 'package:event_app/Event/UserOneEvent.dart';
import 'package:event_app/Homes/HomeScreen.dart';
import 'package:event_app/Onboarding/OnBoarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Usefull/Colors.dart';
import '../Usefull/Buttons.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:http/http.dart' as http;

import '../Usefull/Functions.dart';






class oneUser extends StatefulWidget {
  Map data;
  oneUser({Key? key,required this.data}) : super(key: key);

  @override
  State<oneUser> createState() => _oneUserState();
}

final databaseRef = FirebaseDatabase.instance.reference();

class _oneUserState extends State<oneUser> {
  bool isHide = false;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List<Widget> allInterests = [];
  bool nf = false;
  String nfmsg = "Nothing Found";

  List userIntersts = [];
  List allEventIds = [];
  List<eventItem> allEvents = [];
  List<eventItem> finalallEvents = [];

  bool isFollow = false;
   int followers = 0;


  @override
  void initState() {
    super.initState();
    getEventbyUser();
    getFollow();
    getNumberofFollowers();
  }

  getFollow(){
    if(stateofHomeScreen.widget.data['follow'] != null){
      List a = stateofHomeScreen.widget.data['follow'];
      String ss = "${widget.data['uid']}&${widget.data['name']}&${widget.data['index']}";
      if(a.contains(ss)){
        setState(() {
          isFollow = true;
        });
      }

    }
  }

  getNumberofFollowers() async{
    var ref = await FirebaseDatabase.instance.reference().child('follower');
    await ref.child(widget.data['uid']).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic,dynamic>;
        List a = data.keys.toList();
        setState(() {
          followers = a.length;
        });
      }
    });
    }


  getEventbyUser() async {
    String userid = widget.data['uid'];
    setState(() {
      isHide = true;
    });

    var ref = await FirebaseDatabase.instance.reference().child('userEvent');
    final index = await ref.child(userid).once();
    if (index.snapshot.value != null) {
      final data = index.snapshot.value as Map<dynamic, dynamic>;
      List a = data.keys.toList();
      for (var i in a) {
        getEventswithId(i);
        allEventIds.add(i);
      }
    }
    else {
      if(allEventIds.length == 0) {
        setState(() {
          isHide = false;
          nf = true;
          nfmsg = "No Event in Your City";
        });
      }
    }
  }

  getEventswithId(String id) async {
    var ref = await FirebaseDatabase.instance.reference().child('event');
    final index = await ref.child(id).once();
    if (index.snapshot.value != null) {
      final data = index.snapshot.value as Map<dynamic,dynamic>;
      print(data);
      var a = eventItem(data: data);
      setState(() {
        isHide = false;
        finalallEvents.add(a);
        allEvents.add(a);
      });
    }
    else{
      setState((){
        if(allEvents.length == 0) {
          isHide = false;
          nf = true;
          nfmsg = "Not Event Found";
        }
      });
    }

  }








  late BuildContext mCtx;


  @override
  Widget build(BuildContext context) {

    mCtx = context;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Row(

                          children: [
                            Avatar(widget.data['index'], 40.0),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mainTextFAQS(widget.data['name'], textColor, 20.0, FontWeight.bold, 1),
                                  mainTextFAQS(widget.data['city'], lightGrey, 10.0, FontWeight.normal, 1),
                                ],
                              ),
                            ),

                            IconButton(
                                onPressed: (){
                                  LaunchIt("mailto:${widget.data['email']}");
                                },
                                icon: Icon(Iconsax.message,color: mainColor,)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: secColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      mainText(followers.toString(), Colors.white, 20.0, FontWeight.bold,1),
                                      mainText("FOLLOWERS", Colors.white, 10.0, FontWeight.normal,1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: secColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      mainText(allEvents.length.toString(), Colors.white, 20.0, FontWeight.bold,1),
                                      mainText("EVENTS", Colors.white, 10.0, FontWeight.normal,1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: 10.0,),


                            Visibility(
                              visible: !isFollow,
                              child: selectbtnsss("FOLLOW", () {
                                postFollow();
                              }, mainColor, Colors.white),
                            ),

                            Visibility(
                              visible: isFollow,
                              child: selectbtnsss("FOLLOWING", () {
                                ConfirmUnfollow();
                              }, greenColor, Colors.white),
                            ),





                        SizedBox(height: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mainText("Events", mainColor, 10.0, FontWeight.normal, 1),
                            Visibility(
                                visible: isHide,
                                child: loader()),
                            notFound(nf,"You Have No Events", context),
                            SizedBox(height: 10.0,),
                            Column(
                              children: allEvents,
                            ),
                          ],
                        ),
                      ]
                  )),
            ),
            // loaderss(isHide, context)
          ],
        ),
      ),
    );
  }

  postFollow() async{
    List following = [];
    if(stateofHomeScreen.widget.data['follow'] != null){
      following = stateofHomeScreen.widget.data['follow'];
    }
    String ss = "${widget.data['uid']}&${widget.data['name']}&${widget.data['index']}";
    following.add(ss);
    setState(() {
      isHide = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    Map<String,dynamic> item = {
      "follow":following
    };

    await firestore.collection("user")
        .doc(user!.uid)
        .update(item).then((value) => {
          stateofHomeScreen.widget.data['follow'] = following,
      addFollower(widget.data['uid'], user.uid),
      setState((){
        isFollow = true;
        isHide = false;
      })
    });


  }

  ConfirmUnfollow() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        titleTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 15.0, color: textColor),
        contentTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
        alignment: Alignment.center,
        backgroundColor: bgColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: new Text('Unfollow'),
        content: new Text('Unfollow ${widget.data['name']}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              postunFollow();

            },
            child: new Text(
              'Unfollow',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Cancel',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
        ],
      ),
    )) ?? false;
  }


  postunFollow() async{
    List following = [];
    if(stateofHomeScreen.widget.data['follow'] != null){
      following = stateofHomeScreen.widget.data['follow'];
    }
    String ss = "${widget.data['uid']}&${widget.data['name']}&${widget.data['index']}";

    following.remove(ss);


    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    Map<String,dynamic> item = {
      "follow":following
    };

    await firestore.collection("user")
        .doc(user!.uid)
        .update(item).then((value) => {
          stateofHomeScreen.widget.data['follow'] = following,
      removeFollower(widget.data['uid'], user.uid),
      setState((){
        isFollow = false;
      })
    });
  }

  addFollower(String id, String uid){
    Map<String, String> item = {
      uid:uid,
    };
    final ref = FirebaseDatabase.instance.reference();
    ref.child('follower').child(id).update(item).then((value) => {

    });
  }

  removeFollower(String id, String uid){
    Map<String, String> item = {
      uid:uid,
    };
    final ref = FirebaseDatabase.instance.reference();
    ref.child('follower').child(id).child(uid).remove().then((value) => {

    });
  }

}

class eventItem extends StatefulWidget {
  Map data;
  eventItem({Key? key,required this.data}) : super(key: key);

  @override
  State<eventItem> createState() => _eventItemState();
}

class _eventItemState extends State<eventItem> {
  bool online = true;
  bool multiday = true;
  String date = "";
  String month = "";
  String multi = "Multiday";


  @override
  void initState() {
    setState(() {
      online = widget.data['online'];
      multiday = widget.data['multiday'];
      if(multiday){
        multi = "Multiday";
        date = DateFormat("dd").format(DateTime.parse(widget.data['startDate']));
        month = DateFormat("MMM").format(DateTime.parse(widget.data['startDate']));
      }
      else{
        multi = "Singleday";
        date = DateFormat("dd").format(DateTime.parse(widget.data['date']));
        month = DateFormat("MMM").format(DateTime.parse(widget.data['date']));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        navScreen(oneEvent(data: widget.data, userData: stateofHomeScreen.widget.data,), context, false);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: bgLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  banners(widget.data['index'], widget.data['img'], "",
                      MediaQuery.of(context).size.width,20.0,context),
                  Container(
                    margin: EdgeInsets.only(right: 5.0,top:5.0),
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        smallbtnsss(widget.data['category'],(){},mainColor,Colors.white),
                        SizedBox(height: 3.0,),
                        smallbtnsss(multi,(){},mainColor,Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mainText(widget.data['title'], textColor, 20.0, FontWeight.bold, 1),
                          Visibility(
                              visible: online,
                              child: Row(
                                children: [
                                  onlymainText("Online", secColor, 7.0, FontWeight.normal, 1),
                                  SizedBox(width: 20.0,),
                                  onlymainText(widget.data['sartTime'], textColor, 7.0, FontWeight.normal, 1),
                                  onlymainText(" to ", secColor, 7.0, FontWeight.normal, 1),
                                  onlymainText(widget.data['endTime'], textColor, 7.0, FontWeight.normal, 1),
                                ],
                              )),

                          Visibility(
                              visible: !online,
                              child: Row(
                                children: [
                                  onlymainText("Offline", secColor, 7.0, FontWeight.normal, 1),
                                  SizedBox(width: 20.0,),
                                  onlymainText(widget.data['sartTime'], textColor, 7.0, FontWeight.normal, 1),
                                  onlymainText(" to ", secColor, 7.0, FontWeight.normal, 1),
                                  onlymainText(widget.data['endTime'], textColor, 7.0, FontWeight.normal, 1),

                                ],
                              )),
                          Visibility(
                              visible: !online,
                              child: Row(
                                children: [
                                  Icon(Iconsax.location,color: secColor,size: 10.0,),
                                  onlymainText(widget.data['city'], secColor, 7.0, FontWeight.normal, 1),

                                ],
                              )),

                        ],
                      ),
                    ),
                    Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: mainColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              onlymainText(date, textColor, 7.0, FontWeight.normal, 1),
                              onlymainText(month, textColor, 10.0, FontWeight.normal, 1)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


