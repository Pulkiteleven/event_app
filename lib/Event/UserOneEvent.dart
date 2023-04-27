
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Event/Approve.dart';
import 'package:event_app/Event/Attendance.dart';
import 'package:event_app/Event/Enrolled.dart';
import 'package:event_app/Event/MyQR.dart';
import 'package:event_app/Homes/HomeScreen.dart';
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

import '../Usefull/Functions.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:draggable_home/draggable_home.dart';





class userOneEvent extends StatefulWidget {
  Map data;
  userOneEvent({Key? key,required this.data}) : super(key: key);

  @override
  State<userOneEvent> createState() => _userOneEventState();
}

class _userOneEventState extends State<userOneEvent> {
  bool isHide = false;
  bool isOwner = true;
  Map userData = {'name':'','index':0,'email':''};
  bool online = true;
  bool multiday = true;
  String date = "";
  String endDate = "";
  String startDate = "";
  String multi = "Multiday";
  String onlinet = "Online";
  int left = 0;
  bool enrolled = false;
  List enrolledList = [];
  List notApprovedList = [];
  List AttnedList = [];
  String TodayDate = "";
  bool approve = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  List everyEnrolledData = [];

  @override
  void initState() {
    setState(() {
      TodayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
      online = widget.data['online'];
      approve = widget.data['approve'];
      if(!online){
        onlinet = "Offline";
      }
      multiday = widget.data['multiday'];
      if(multiday){
        multi = "Multiday";
        startDate = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['startDate']));
        endDate = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['endDate']));
      }
      else{
        multi = "Singleday";
        date = DateFormat("dd MMM yyyy").format(DateTime.parse(widget.data['date']));

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
          List allenrolled = aa.keys.toList();
          List allenrolleddata = aa.values.toList();
          if(approve){

            if(multiday){
              for(var i in allenrolleddata){
                Map abc = i as Map;
                if(!everyEnrolledData.contains(abc)){
                  print("Batman $abc");
                  everyEnrolledData.add(abc);
                }
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
                  if(!AttnedList.contains(finalID)) {
                    AttnedList.add(finalID);
                  }
                }
              }
            }
            else{
              for(var i in allenrolleddata){
                if(!everyEnrolledData.contains(i)){
                  everyEnrolledData.add(i);
                }
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
                  if(!AttnedList.contains(id)) {
                    AttnedList.add(id);
                  }
                }
              }
            }
          }
          else{
            allenrolled.remove("id");
            print(allenrolled);
            enrolledList = allenrolled;
            notApprovedList = allenrolled;
            if(multiday){
              for(var i in allenrolleddata){
                Map abc = i as Map;
                if(!everyEnrolledData.contains(abc)){
                  everyEnrolledData.add(abc);
                }
                String id = abc['id'];

                Map attendsss = abc['attend'] as Map;
                List atteList = attendsss.keys.toList();
                for(var x in atteList){
                  String finalID = id + "&" + x;
                  if(!AttnedList.contains(finalID)) {
                    AttnedList.add(finalID);
                  }
                }
              }
            }
            else{
              for(var i in allenrolleddata){
                if(!everyEnrolledData.contains(i)){
                  everyEnrolledData.add(i);
                  print(i);
                }
                List aaa = i.toString().split("&");
                String id = aaa[0];
                String approve = aaa[1];
                String attend = aaa[2];

                if(attend == "attend"){
                  if(!AttnedList.contains(id)) {
                    AttnedList.add(id);
                  }
                }
              }
            }

          }
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
                    onlymainText(widget.data['category'] + ", $onlinet" , mainColor, 10.0, FontWeight.bold,1),
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
                                visible: online,
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.link,color: mainColor,),
                                    SizedBox(width: 5.0,),
                                    TextButton(
                                        onPressed: (){
                                          LaunchIt(widget.data['link']);
                                        },
                                        child: mainText(widget.data['link'].toString(),mainColor, 10.0, FontWeight.normal, 2)),
                                  ],
                                ),
                              ),

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
                    Container(
                      height: 70.0,
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(Iconsax.scan_barcode,color: textColor,),
                              mainText("GENERATE QR FOR EVENT", textColor, 15.0, FontWeight.bold, 1),
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
                          navScreen(myQR(text: "QR for this ${widget.data['title']}", qrs: widget.data['id']),context,false);
                        },
                      ),
                    ),


                    SizedBox(height: 20.0,),

                    Visibility(
                      visible: online,
                      child: Container(
                        height: 70.0,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Spacer(),
                                Icon(Iconsax.scan,color: textColor,),
                                mainText("GENERATE QR FOR ATTENDANCE", textColor, 15.0, FontWeight.bold, 1),
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
                            navScreen(myQR(text: "QR for Attendance\nfor Event ${widget.data['title']}\nof $TodayDate", qrs: "${widget.data['id']}&$TodayDate"), context, false);
                          },
                        ),
                      ),
                    ),


                    Visibility(
                      visible: !online,
                      child: Container(
                        height: 70.0,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Spacer(),
                                Icon(Iconsax.scan,color: textColor,),
                                mainText("SCAN QR FOT ATTENDANCE", textColor, 15.0, FontWeight.bold, 1),
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
                            Scanit();
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Visibility(
                          visible: notApprovedList.length - enrolledList.length - 1 > 0 && approve,
                          child: Expanded(
                            child: Container(
                              height: 70.0,
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Icon(Iconsax.verify,color: textColor,),
                                          mainText("APPROVE", textColor, 15.0, FontWeight.bold, 1),
                                          Spacer(),
                                        ],
                                      ),
                                      mainText("${notApprovedList.length - 1 - enrolledList.length} Applicants", textColor, 10.0, FontWeight.bold, 1),
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
                                  navScreen(approveScreen(data:everyEnrolledData,multiday: multiday,eid: widget.data['id'],), context, false);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Visibility(
                          visible: enrolledList.length > 0,
                          child: Expanded(
                            child: Container(
                              height: 70.0,
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Icon(Iconsax.pen_add,color: textColor,),
                                          mainText("ENROLLED", textColor, 15.0, FontWeight.bold, 1),
                                          Spacer(),
                                        ],
                                      ),
                                      mainText("${enrolledList.length} Applicants", textColor, 10.0, FontWeight.bold, 1),
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
                                  navScreen(enrollScreen(data:everyEnrolledData,multiday: multiday,eid: widget.data['id'],), context, false);

                                },
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Visibility(
                          visible: AttnedList.length > 0,
                          child: Expanded(
                            child: Container(
                              height: 70.0,
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Icon(Iconsax.book,color: textColor,),
                                          mainText("ATTENDANCE", textColor, 15.0, FontWeight.bold, 1),
                                          Spacer(),
                                        ],
                                      ),
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
                                  print(everyEnrolledData);
                                  navScreen(attendanceScreen(data:everyEnrolledData,multiday: multiday,eid: widget.data['id'],), context, false);

                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
    String uid = barcodeScanRes.split("&")[0];
    String name = barcodeScanRes.split("&")[1];
    String img = barcodeScanRes.split("&")[2];
    if(multiday){
      String id = barcodeScanRes + "&" + TodayDate;
      if(AttnedList.contains(uid + "&" + TodayDate)){
        toaster("Today's Attendance Already Added");
      }
      else if (!enrolledList.contains(uid) && notApprovedList.contains(uid)) {
        toaster("User is Not Approved");
      }
      else if (enrolledList.contains(uid)) {
        markAttendancemulti(uid,);
      }
      else{
        toaster("User is not Enrolled");
      }
    }
    else {
      if(AttnedList.contains(uid)){
        toaster("Attendance Already Added");
      }
      else if (!enrolledList.contains(uid) && notApprovedList.contains(uid)) {
        toaster("User is Not Approved");
      }
      else if (enrolledList.contains(uid)) {
        markAttendancesingle(uid,name,img);
      }
      else {
        toaster("User is not Enrolled");
      }
    }
  }

  markAttendancesingle(String id,String name, String img){

    Map<String,dynamic> item = {
      id:"$id&approve&attend&$name&$img"
    };

    final ref = FirebaseDatabase.instance.reference();
    ref.child('event').child(widget.data['id']).child('enrolled').update(item).then((value) => {
      toaster("Marked Attendance for this user"),
    });
  }

  markAttendancemulti(String id){

    Map<String,dynamic> item = {
      TodayDate:TodayDate
    };

    final ref = FirebaseDatabase.instance.reference();
    ref.child('event').child(widget.data['id']).child('enrolled').child(id).child('attend').update(item).then((value) => {
      toaster("Marked Attendance for this user"),
    });
  }



}
