
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Event/OneEvent.dart';
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

import 'package:http/http.dart' as http;

import '../Usefull/Functions.dart';







late _myFeedsState stateofFeeds;

class myFeeds extends StatefulWidget {
  Map data;
  myFeeds({Key? key,required this.data}) : super(key: key);

  @override
  State<myFeeds> createState() {
    stateofFeeds = _myFeedsState();
    return stateofFeeds;
  }
}

final databaseRef = FirebaseDatabase.instance.reference();

class _myFeedsState extends State<myFeeds> {
  bool isHide = false;
  bool nf = false;
  String nfmsg = "Nothing Found";

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List allEventIds = [];
  List<eventItem> allEvents = [];
  List<eventItem> finalallEvents = [];


  List<filterbtnss> filterList = [];
  bool isFilter = false;
  String city = "";
  String state = "";
  String place = "Select City";
  bool isCity = false;

  List<Widget> stateList = [];
  List<Widget> cityList = [];
  List citiesList = [];

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getFollowing();
  }



  getFollowing() async{
    if(widget.data['follow'] != null) {
      List followers = widget.data['follow'];
      for(var i in followers){
        String id = i.toString().split("&")[0];
        String name = i.toString().split("&")[1];
        String img = i.toString().split("&")[2];
        getEventbyUser(id);
        var a = filterbtnss(title: name, id: id, index: img);
        setState(() {
          filterList.add(a);
        });
        if(filterList.length == 0){
          setState(() {
            nf = true;
          });
        }
      }
      if(filterList.length == 0){
        setState(() {
          nf = true;
        });
      }

    }
  }

  getEventbyUser(String id) async {
    setState(() {
      isHide = true;
    });

    var ref = await FirebaseDatabase.instance.reference().child('userEvent');
    final index = await ref.child(id).once();
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
          nfmsg = "No Event Found";
        });
      }
    }
  }

  getEventswithId(String id) async {
    DateTime currentTime = DateTime.now();
    DateTime DateToday = DateTime.parse(
        "${currentTime.year}-${currentTime.month < 10 ? '0${currentTime.month}' : currentTime.month}-${currentTime.day < 10 ? '0${currentTime.day}' : currentTime.day} 00:00:00");

    var ref = await FirebaseDatabase.instance.reference().child('event');
    final index = await ref.child(id).once();
    if (index.snapshot.value != null) {
      final data = index.snapshot.value as Map<dynamic,dynamic>;
      DateTime eventDateFinal = DateTime.now();
      if(data['multiday']){
        DateTime d = DateTime.parse(data['endDate']);
        eventDateFinal = DateTime.parse(
            "${d.year}-${d.month < 10 ? '0${d.month}' : d.month}-${d.day < 10 ? '0${d.day}' : d.day} 00:00:00");

      }
      else{
        DateTime d = DateTime.parse(data['date']);
        eventDateFinal = DateTime.parse(
            "${d.year}-${d.month < 10 ? '0${d.month}' : d.month}-${d.day < 10 ? '0${d.day}' : d.day} 00:00:00");

      }
      print(data);
      var a = eventItem(data: data,userData: widget.data,);
      setState(() {
        nf = true;
        isHide = false;
        if(DateToday.isBefore(eventDateFinal) || eventDateFinal.isAtSameMomentAs(DateToday)) {
          if(data['from'] != _auth.currentUser!.uid) {
            finalallEvents.add(a);
            allEvents.add(a);
          }
        }
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

  applyfiler(bool on, String id){
    setState(() {
      allEvents = [];
    });
    if(on){
        for(var i in finalallEvents){
          if(i.data['from'] == id){
            setState(() {
              if(!allEvents.contains(i)) {
                allEvents.add(i);
              }
            });
          }
        }
        changeAll(true);
    }
    else{
      setState(() {
        allEvents = finalallEvents;
      });
      changeAll(false);

    }
  }

  changeAll(bool a) async{
    for(var i in filterList){
      i.stateoffilter.setState(() {
        i.stateoffilter.blur = a;
        i.stateoffilter.selected = a;
      });
    }
  }



  late BuildContext mCtx;


  @override
  Widget build(BuildContext context) {
    mCtx = context;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: bgLight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: filterList,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:allEvents,
                ),
              ),
            ],
          ),
        ),
        loaderss(isHide, context),
        notFound(allEvents.isEmpty && nf,nfmsg, context),

      ],
    );
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






class filterbtnss extends StatefulWidget {
  String title;
  String index;
  String id;
  filterbtnss({Key? key,required this.title,required this.id,required this.index}) : super(key: key);

  late _filterbtnssState stateoffilter;

  @override
  State<filterbtnss> createState() {
    stateoffilter = _filterbtnssState();
    return stateoffilter;
  }
}

class _filterbtnssState extends State<filterbtnss> {
  bool blur = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: (){
          if(selected){
            stateofFeeds.applyfiler(false,widget.id);
          }
          else{
            stateofFeeds.applyfiler(true,widget.id);
            setState(() {
              blur = false;
              selected = true;
            });
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Avatar(widget.index, 30.0),
                mainText(widget.title, textColor, 10.0, FontWeight.normal, 1),
              ],
            ),
            Visibility(
                visible: blur,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color(0x83000000),
                ))
          ],
        ),
      ),
    );
  }
}



