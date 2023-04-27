
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Homes/HomeScreen.dart';
import 'package:event_app/OneUser/OneUser.dart';
import 'package:event_app/Usefull/Buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Usefull/Colors.dart';

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
import 'package:iconsax/iconsax.dart';


import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../Usefull/Functions.dart';
import 'package:draggable_home/draggable_home.dart';




class oneEvent extends StatefulWidget {
  Map data;
  Map userData;
  oneEvent({Key? key,required this.data,required this.userData}) : super(key: key);

  @override
  State<oneEvent> createState() => _oneEventState();
}

class _oneEventState extends State<oneEvent> {
  bool isHide = false;
  bool isOwner = true;
  Map userData = {'name':'','index':"hello",'email':''};
  bool online = true;
  bool multiday = true;
  String date = "";
  String endDate = "";
  String startDate = "";
  String multi = "Multiday";
  String onlinet = "Online";
  int left = 0;

  bool enrolled = false;
  bool approved = false;
  String enrollText = "ENROLLED";

  bool approve = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool showLink = false;
  List attendanceList = [];
  List enrolledList = [];
  List notApprovedList = [];
  String TodayDate = "";
  List attendedOn = [];

  @override
  void initState() {
    setState(() {
      approve = widget.data['approve'];
      TodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
      DateTime dateToday = DateTime.now();
      online = widget.data['online'];
      if(!online){
        onlinet = "Offline";
      }
      multiday = widget.data['multiday'];
      if(multiday){
        multi = "Multiday";
        startDate = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['startDate']));
        endDate = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['endDate']));
        print(dateToday.difference(DateTime.parse(widget.data['startDate'])));
        if(dateToday.difference(DateTime.parse(widget.data['startDate'])) <= Duration(hours: 24)){
          showLink = true;
        }
      }
      else{
        multi = "Singleday";
        date = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['date']));
        if(dateToday.difference(DateTime.parse(widget.data['date'])) <= Duration(hours: 24)){
          showLink = true;
        }
      }
    });
    getEventswithId(widget.data['id']);
    getuserData();
  }

  getEventswithId(String id) async {
    var ref = await FirebaseDatabase.instance.reference().child('event');
    await ref.child(id).onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic,dynamic>;
        print(data);

        setState(() {
          Map aa = data['enrolled'];
          Map atend = data['attend'];
          List allenrolled = aa.keys.toList();
          List allenrolleddata = aa.values.toList();

          if(approve){
            if(multiday){
              for(var i in allenrolleddata){
                Map abc = i as Map;
                String id = abc['id'];
                if(!notApprovedList.contains(id)){
                  notApprovedList.add(id);
                }
                if(abc['approve']){
                  if(!enrolledList.contains(id)) {
                    enrolledList.add(id);
                  }
                }

                Map attendsss = abc['attend'] as Map;
                List atteList = attendsss.keys.toList();
                for(var x in atteList){
                  String finalID = id + "&" + x;
                  if(!attendanceList.contains(finalID)) {
                    attendanceList.add(finalID);
                  }
                }

              }
            }
            else{
              for(var i in allenrolleddata){
                List aaa = i.toString().split("&");
                String id = aaa[0];
                String approve = aaa[1];
                String attend = aaa[2];

                if(!notApprovedList.contains(id)){
                  notApprovedList.add(id);
                }
                if(approve == "approve"){
                  if(!enrolledList.contains(id)) {
                    enrolledList.add(id);
                  }
                }
                if(attend == "attend"){
                  if(!attendanceList.contains(id)) {
                    attendanceList.add(id);
                  }
                }
              }
            }

          }
          else{
            enrolledList = allenrolled;
            notApprovedList = allenrolled;
            if(multiday){
              for(var i in allenrolleddata){
                Map abc = i as Map;
                String id = abc['id'];

                Map attendsss = abc['attend'] as Map;
                List atteList = attendsss.keys.toList();
                for(var x in atteList){
                  String finalID = id + "&" + x;
                  if(!attendanceList.contains(finalID)) {
                    attendanceList.add(finalID);
                  }
                }
              }
            }
            else{
              for(var i in allenrolleddata){
                List aaa = i.toString().split("&");
                String id = aaa[0];
                String approve = aaa[1];
                String attend = aaa[2];

                if(attend == "attend"){
                  if(!attendanceList.contains(id)) {
                    attendanceList.add(id);
                  }
                }
              }
            }
          }
          getattendanceDay();
          if(allenrolled.contains(_auth.currentUser!.uid)){
             enrolled = true;
          }
          if(!approve) {
            left = data['capacity'] - aa.keys
                .toList()
                .length + 1;
          }
          else{
            left = data['capacity'] - enrolledList.length;
          }
          widget.data = data;
          isHide = false;
        });
      }
    });
  }

  getattendanceDay(){
    if(multiday){
      attendanceList.remove(_auth.currentUser!.uid + "&id");
      for(var i in attendanceList) {
        if (i.toString().contains("&")) {
          String id = i.toString().split("&")[0];
          String date = i.toString().split("&")[1];

          if (id == _auth.currentUser!.uid) {
            setState(() {
              attendedOn.add(date);
            });
          }
        }
      }
    }
  }

  getuserData() async{
    setState(() {
      isOwner = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('user')
        .where("uid", isEqualTo: widget.data['from'])
        .get();

    if (querySnapshot != null) {
      final allData = querySnapshot.docs.map((e) => e.data()).toList();
      if (allData.length != 0) {
        var b = allData[0] as Map<String, dynamic>;
        setState(() {
          userData = b;
          isOwner = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        body: DraggableHome(
          title: mainText("", textColor, 10.0, FontWeight.normal, 1),
          alwaysShowLeadingAndAction: true,
          backgroundColor: bgColor,
          
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left,color: textColor,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          headerExpandedHeight: 0.25,
          stretchMaxHeight: 0.27,
          appBarColor: bgLight,
          headerWidget: banners(widget.data['index'], widget.data['img'], "",
              MediaQuery.of(context).size.width, 20.0,context),
          body: [Stack(

            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    onlymainText(widget.data['category'] + ", " + onlinet, mainColor, 10.0, FontWeight.bold,1),
                    mainTextFAQS(widget.data['title'], textColor, 25.0, FontWeight.bold,1),
                    mainTextFAQS(widget.data['desc'], mainColor, 10.0, FontWeight.normal,5),
                    SizedBox(height: 20.0,),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        color: bgLight,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.clock,color: mainColor,),
                                  SizedBox(width: 5.0,),
                                  mainText(widget.data['sartTime'], textColor, 15.0, FontWeight.normal, 1),
                                  mainText(" to ", secColor, 7.0, FontWeight.normal, 1),
                                  mainText(widget.data['endTime'], textColor, 15.0, FontWeight.normal, 1),
                                ],
                              ),
                              SizedBox(height: 20.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Iconsax.calendar,color: mainColor,),
                                  SizedBox(width: 5.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      onlymainText(multi + "  ", mainColor, 15.0, FontWeight.normal, 1),
                                      Visibility(
                                          visible: !multiday,
                                          child: mainText(date, textColor, 15.0, FontWeight.normal, 1)),
                                      Visibility(
                                        visible: multiday,
                                        child: Row(
                                          children: [
                                            mainText(startDate, textColor, 15.0, FontWeight.normal, 1),
                                            mainText(" to ", secColor, 7.0, FontWeight.normal, 1),
                                            mainText(endDate, textColor, 15.0, FontWeight.normal, 1),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(height: 20.0,),

                              Visibility(
                                visible: !online,
                                child: Row(
                                  children: [
                                    Icon(Iconsax.building_3,color: mainColor,),
                                    SizedBox(width: 5.0,),
                                    mainText(widget.data['city'], textColor, 15.0, FontWeight.normal, 1),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Visibility(
                                visible: !online,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Iconsax.location,color: mainColor,),
                                    SizedBox(width: 5.0,),
                                    mainText(widget.data['venu'], textColor, 15.0, FontWeight.normal, 2),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: !online,
                                  child: SizedBox(height: 20.0,)),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Iconsax.people,color: mainColor,),
                                  SizedBox(width: 5.0,),
                                  mainText(widget.data['capacity'].toString(), textColor, 15.0, FontWeight.normal, 2),
                                  SizedBox(width: 10.0,),
                                  mainText("${left} left", mainColor, 15.0, FontWeight.normal,1),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    Visibility(
                      visible: showLink && online && enrolled,
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: bgLight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Iconsax.link,color: mainColor,),
                                SizedBox(width: 5.0,),
                                TextButton(
                                    onPressed: (){
                                      LaunchIt(widget.data['link']);
                                    },
                                    child: mainText(widget.data['link'].toString(), textColor, 15.0, FontWeight.normal, 2)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: showLink && online,
                        child: SizedBox(height: 20.0,)),

                    mainText(" Organizer", mainColor, 10.0, FontWeight.normal,1),
                    Visibility(
                      visible: !isOwner,
                      child: GestureDetector(
                        onTap: (){
                          navScreen(oneUser(data: userData), context, false);
// ;                          oneUser(data: userData);
                        },
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: bgLight,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Avatar(userData['index'], 25.0),
                                  SizedBox(width: 5.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      mainText(userData['name'], textColor, 15.0, FontWeight.bold, 2),
                                      onlymainText(userData['email'], Colors.grey, 10.0, FontWeight.bold, 2),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(onPressed: (){
                                    LaunchIt("mailto:${userData['email']}");
                                  }, icon: Icon(Iconsax.message,color: mainColor,))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Visibility(
                      visible: !enrolled && left != 0,
                      child: Container(
                        height: 70.0,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Spacer(),
                                mainText("ENROLL NOW", textColor, 15.0, FontWeight.bold, 1),
                                Spacer(),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(mainColor),
                              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: mainColor)))),
                          onPressed: (){
                            confirmEnroll();
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: !enrolled && left == 0,
                      child: Container(
                        height: 70.0,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Spacer(),
                                mainText("NO SEATS LEFT", textColor, 15.0, FontWeight.bold, 1),
                                Spacer(),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(errorColor),
                              backgroundColor: MaterialStateProperty.all<Color>(errorColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: errorColor)))),
                          onPressed: (){
                            toaster("The Event is Full");
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: enrolledList.contains(_auth.currentUser!.uid) || notApprovedList.contains(_auth.currentUser!.uid),
                      child: Container(
                        height: 70.0,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Spacer(),
                                Visibility(
                                    visible: enrolledList.contains(_auth.currentUser!.uid),
                                    child: mainText("ENROLLED", textColor, 15.0, FontWeight.bold, 1)),

                                Visibility(
                                    visible: !enrolledList.contains(_auth.currentUser!.uid),
                                    child: mainText("PENDING", textColor, 15.0, FontWeight.bold, 1)),
                                Spacer(),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(greenColor),
                              backgroundColor: MaterialStateProperty.all<Color>(greenColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: greenColor)))),
                          onPressed: (){
                            // toaster("You are Already Enrolled");
                          },
                        ),
                      ),
                    ),


                    Visibility(
                      visible: enrolled && online,
                      child:SizedBox(height: 20.0,),),

                    Visibility(
                        visible: enrolled && online,
                        child:
                        Container(
                          height: 70.0,
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Icon(Iconsax.scan_barcode,color: textColor,),
                                  mainText(" SCAN FOR ATTENDANCE", textColor, 15.0, FontWeight.bold, 1),
                                  Spacer(),
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(mainColor),
                                backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(color: mainColor)))),
                            onPressed: (){
                              Scanit();
                            },
                          ),
                        )
                    ),

                    SizedBox(height: 20.0,),

                    Visibility(
                        visible: !multiday && attendanceList.contains(_auth.currentUser!.uid),
                        child:
                        Container(
                          height: 70.0,
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Icon(Iconsax.tick_circle,color: textColor,),
                                  mainText(" ATTENDED", textColor, 15.0, FontWeight.bold, 1),
                                  Spacer(),
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(mainColor),
                                backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(color: mainColor)))),
                            onPressed: (){
                              toaster("You have Attended this Event");
                            },
                          ),
                        )
                    ),

                    Visibility(
                        visible: multiday && attendedOn.isNotEmpty,
                        child:
                        Column(
                          children: [
                            Container(
                              height: 70.0,
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Icon(Iconsax.tick_circle,color: textColor,),
                                      mainText(" ATTENDED ON", textColor, 15.0, FontWeight.bold, 1),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(mainColor),
                                    backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(color: mainColor)))),
                                onPressed: (){
                                  toaster("You have Attended this Event");
                                },
                              ),
                            ),
                            mainTextFAQS(attendedOn.join(", "), textColor, 15.0, FontWeight.normal, 5),
                          ],
                        )
                    ),


                  ],
                ),
              ),
              loaderss(isHide, context),
            ],
          )],
        )
      ),
    );
  }

  Scanit() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.QR);
    print(barcodeScanRes);
    FirebaseAuth auth = FirebaseAuth.instance;
    if(barcodeScanRes.contains("&") && barcodeScanRes.contains(widget.data['id'])){
      String date = barcodeScanRes.split("&")[1];
      if(multiday){
        String id = auth.currentUser!.uid + "&" + date;
        if(attendanceList.contains(id)){
          toaster("Today's Attendance Added");
        }
        else if (!enrolledList.contains(auth.currentUser!.uid) && notApprovedList.contains(auth.currentUser!.uid)) {
          toaster("User is Not Approved");
        }
        else if (enrolledList.contains(auth.currentUser!.uid)) {
          markAttendancemulti(auth.currentUser!.uid);
        }
        else{
          toaster("User is not Enrolled");
        }
      }

      else {
        if(attendanceList.contains(auth.currentUser!.uid)){
          toaster("Attendance Already Added");
        }
        else if (!enrolledList.contains(auth.currentUser!.uid) && notApprovedList.contains(auth.currentUser!.uid)) {
          toaster("User is Not Approved");
        }
        else if (enrolledList.contains(auth.currentUser!.uid)) {
          markAttendancesingle(auth.currentUser!.uid);
        }
        else {
          toaster("User is not Enrolled");
        }
      }
    }
    else{
      toaster("Invalid QR");
    }
  }



  markAttendancesingle(String id){


    Map<String,dynamic> item = {
      id:"$id&approve&attend&${widget.userData['name']}&${widget.userData['index']}"
    };

    final ref = FirebaseDatabase.instance.reference();
    ref.child('event').child(widget.data['id']).child('enrolled').update(item).then((value) => {
      toaster("Marked Attendance for this user"),
    });
  }

  markAttendancemulti(String id){



    Map<String,dynamic> item = {
      TodayDate:TodayDate,
    };

    final ref = FirebaseDatabase.instance.reference();
    ref.child('event').child(widget.data['id']).child('enrolled').child(id).child('attend').update(item).then((value) => {
      toaster("Marked Attendance for this user"),
    });
  }


  Future<bool> confirmEnroll() async {
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
        title: new Text('Enroll in this Event'),
        content: new Text('Do You Want to Enroll in this Event'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              enrollUser();

            },
            child: new Text(
              'Yes',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
        ],
      ),
    )) ?? false;
  }

  enrollUser(){
    setState((){
      isHide = true;
    });

    Map<String,dynamic> item = {};

    if(multiday) {
      if (approve) {
        item = {
          _auth.currentUser!.uid: {
            'id': _auth.currentUser!.uid,
            'approve': false,
            'name': widget.userData['name'],
            'img': widget.userData['index'],
            'attend': {
              'id': 'id',
            }
          }
        };
      }
      else {
        item = {
          _auth.currentUser!.uid: {
            'id': _auth.currentUser!.uid,
            'approve': true,
            'name': widget.userData['name'],
            'img': widget.userData['index'],
            'attend': {
              'id': 'id',
            }
          }
        };
      }
    }
    else{
      if(approve) {
        item = {
          _auth.currentUser!.uid: "${_auth.currentUser!.uid}&not&not&${widget
              .userData['name']}&${widget.userData['index']}"
        };
      }
      else{
        item = {
          _auth.currentUser!.uid: "${_auth.currentUser!.uid}&approve&not&${widget
              .userData['name']}&${widget.userData['index']}"
        };
      }
    }


    final ref = FirebaseDatabase.instance.reference();
    ref.child('event').child(widget.data['id']).child('enrolled').update(item).then((value) => {
      toaster("You Are Enrolled for this event"),
      setState((){
        enrolled = true;
      }),
      posttoUser()
    });
  }

  posttoUser() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    List userEnrolled = [];
    if(stateofHomeScreen.widget.data['enrolled'] != null) {
      userEnrolled = stateofHomeScreen.widget.data['enrolled'];
    }
    stateofHomeScreen.setState(() {
      stateofHomeScreen.widget.data['enrolled'] = userEnrolled;
    });
    userEnrolled.add(widget.data['id']);
    Map<String,dynamic> item = {
      "enrolled":userEnrolled,
    };

    await firestore.collection("user")
        .doc(user!.uid)
        .update(item);

    setState(() {
      isHide = false;
    });
  }

}
