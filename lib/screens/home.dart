
import 'package:event_app/AlooDart.dart';
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Event/LoadEvent.dart';
import 'package:event_app/Event/OneEvent.dart';
import 'package:event_app/Homes/HomeScreen.dart';
import 'package:event_app/Usefull/Buttons.dart';
import 'package:event_app/screens/allEvents.dart';
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



class Home extends StatefulWidget {
  Map data;
  Home({Key? key,required this.data}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHide = false;
  
  bool myEnrolledEvent = false;
  bool nf = false;
  String nfmsg = "Not Found";

  List<eventItem> finalallEventss = [];
  List<eventItem> allEventss = [];
  

  @override
  void initState() {
    getEventList();
  }

  getEventList(){
    if(widget.data['enrolled'] != null){
      setState(() {
        myEnrolledEvent = true;
      });
      List enrolledEvents = widget.data['enrolled'];
      for(var i in enrolledEvents){
        getEventswithId(i);
      }
    }
    else{
      setState(() {
        nf = true;
      });
    }
  }

  getEventswithId(String id) async {
    var ref = await FirebaseDatabase.instance.reference().child('event');
    final index = await ref.child(id).once();
    if (index.snapshot.value != null) {
      final data = index.snapshot.value as Map<dynamic,dynamic>;
      print(data);
      var a = eventItem(data: data,userData: widget.data,);
      setState(() {
        nf = true;
        isHide = false;
        myEnrolledEvent = false;
        allEventss.add(a);
      });
    }
    else{
      setState((){
        if(allEventss.length == 0) {
          isHide = false;
          nf = true;
          myEnrolledEvent = false;
          nfmsg = "Not Event Found";
        }
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainText("hello", mainColor, 10.0, FontWeight.normal, 1),
              Row(
                children: [
                  mainText(widget.data['name'], textColor, 35.0, FontWeight.bold, 1),
                  Spacer(),
                  Avatar(widget.data['index'], 20.0),
                ],
              ),
              SizedBox(height: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  color: bgLight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Iconsax.location,color: mainColor,),
                        SizedBox(width: 5.0,),
                        mainText(widget.data['city'], mainColor, 10.0, FontWeight.bold, 1),

                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0,),


              GestureDetector(
                onTap: (){
                  navScreen(alooDart(data: allEvents(data: widget.data,)), context, false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.38,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: mainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          mainTextFAQS("Find Events", bgColor, 28.0, FontWeight.bold, 1),
                          mainTextFAQS("in your City", textColor, 30.0, FontWeight.bold, 1),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.0,),
              
              Row(
                children: [
                  mainText("Enrolled Events", mainColor, 10.0, FontWeight.normal, 1),
                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Iconsax.arrow_circle_right,color: mainColor,)),
                ],
              ),
              SizedBox(height: 5.0,),
              Column(
                children: [
                  Visibility(
                      visible: myEnrolledEvent,
                      child: CircularProgressIndicator(
                        color: mainColor,
                      )),
                  notFound(nf && allEventss.length == 0, "Not Enrolled in any Event", context),
                  Column(
                    children: allEventss,
                  )
                ],
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
                        Icon(Iconsax.scan,color: textColor,),
                        mainText(" SCAN AND FIND EVENT", textColor, 15.0, FontWeight.bold, 1),
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
              ),

            ],
          ),
        ),

        loaderss(isHide, context)
      ],
    );
  }

  Scanit() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.QR);
    print(barcodeScanRes);
    navScreen(loadEvent(id: barcodeScanRes,userData: widget.data,), context, false);
  }


}



class eventItem extends StatefulWidget {
  Map data;
  Map userData;
  eventItem({Key? key,required this.data,required this.userData}) : super(key: key);

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
        navScreen(oneEvent(data: widget.data,userData: widget.userData,), context, false);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: bgLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                banners(widget.data['index'], widget.data['img'], "",
                    80.0,20.0,context),
                SizedBox(width: 5.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainText(widget.data['title'], textColor, 15.0, FontWeight.bold, 1),
                      onlymainText("on $date $month", mainColor, 10.0, FontWeight.normal, 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
