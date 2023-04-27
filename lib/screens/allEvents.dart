
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







late _allEventsState stateofEvents;

class allEvents extends StatefulWidget {
  Map data;
  allEvents({Key? key,required this.data}) : super(key: key);

  @override
  State<allEvents> createState() {
    stateofEvents = _allEventsState();
    return stateofEvents;
  }
}

final databaseRef = FirebaseDatabase.instance.reference();

class _allEventsState extends State<allEvents> {
  bool isHide = false;
  bool nf = false;
  String nfmsg = "Nothing Found";

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List userIntersts = [];
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
    getEventbyCity();
    getCategory();
  }

  getCategory() async {
    setState(() {
      isFilter = true;
      filterList.add(filterbtnss(title: "online", bg: bgColor, text: mainColor));
    });
    User? user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('category')
        .get();

    if (querySnapshot != null) {
      final allData = querySnapshot.docs.map((e) => e.data()).toList();
      if (allData.length != 0) {
        var b = allData[0] as Map<String, dynamic>;
        print(b);
        List category = b['category'];
        for(var i in category){
          var a = filterbtnss(title: i, bg: bgColor, text: mainColor);
          setState(() {
            filterList.add(a);
            isFilter = false;
          });
        }
      }
    }
  }


  getEventbyCity() async {
    String userCity = widget.data['city'];
    List abc = [userCity,'online'];
    setState(() {
      isHide = true;
      place = widget.data['city'];
    });
    for(var s in abc) {
      var ref = await FirebaseDatabase.instance.reference().child('cityEvent');
      final index = await ref.child(s).once();
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
  }

  getEventbyCustomCity(String city) async {
    String userCity = city;
    List abc = [userCity,'online'];
    setState(() {
      isHide = true;
      city = widget.data['city'];
      allEvents = [];
      finalallEvents = [];
    });
    for(var s in abc) {
      var ref = await FirebaseDatabase.instance.reference().child('cityEvent');
      final index = await ref.child(s).once();
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
      if(id == "online"){
        for(var i in finalallEvents){
          if(i.data['online']){
            setState(() {
              if(!allEvents.contains(i)) {
                allEvents.add(i);
              }
            });
          }
        }
      }
      else{
        for(var i in finalallEvents){
          if(i.data['category'] == id){
            setState(() {
              if(!allEvents.contains(i)) {
                allEvents.add(i);
              }
            });
          }
        }
      }
      changeAll();
    }
    else{
      setState(() {
        allEvents = finalallEvents;
      });
    }
  }

  changeAll() async{
    for(var i in filterList){
      i.stateoffilter.setState(() {
        i.stateoffilter.widget.bg = bgColor;
        i.stateoffilter.widget.text = mainColor;
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
            children: [

              Row(
                children: [
                  GestureDetector(
                    onTap:(){
                      ShowStateCityPicker(context);
                    },
                    child: Container(
                      // color: bgLight,
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: textColor,width: 1.0),
                        ),
                        color: transparent_overlay,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              onlymainText("current city", textColor, 7.0, FontWeight.normal, 1),
                              onlymainText(place.split(",")[0], textColor, 10.0, FontWeight.normal, 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: isFilter,
                      child: Container(
                      width: 10.0,
                      height: 10.0,
                      child: CircularProgressIndicator(color: mainColor,))),
                  Expanded(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: filterList,
                        )),
                  ),
                ],
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

  ShowStateCityPicker(BuildContext ctx){

    state = "";
    super.setState(() {
      citiesList = [];
    });
    for(var i in allStates){
      var a = ListTile(
        title: Row(
          children: [
            mainText(i, textColor, 15.0, FontWeight.normal, 1),
            Spacer(),
          ],
        ),
        leading: Icon(Iconsax.map,color: mainColor,),
        onTap: (){
          state = i;
          Navigator.pop(context);
          ShowCityPicker(context,i);
        },
      );
      setState(() {
        stateList.add(a);
      });
    }

    showBarModalBottomSheet(context: ctx,
        builder: (context){
          return
            StatefulBuilder(builder: (BuildContext context,StateSetter setState){
              return Container(
                // height: 200.0,
                color: bgColor,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 36,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,

                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: mainColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "State",
                          counterText: "",
                          prefixIcon: Icon(Iconsax.search_favorite,color: mainColor,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: errorColor
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: errorColor
                              )
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: secColor
                              )
                          ),
                          border:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          )
                      ),

                      onChanged: (text){
                        setState(() {
                          stateList = [];
                        });
                        for(var i in allStates){
                          if(i.toString().toUpperCase().contains(text.toUpperCase())){
                            var a = ListTile(
                              title: Row(
                                children: [
                                  mainText(i, textColor, 15.0, FontWeight.normal, 1),
                                  Spacer(),
                                ],
                              ),
                              leading: Icon(Iconsax.map,color: mainColor,),
                              onTap: (){
                                state = i;
                                Navigator.pop(context);
                                ShowCityPicker(context,i);
                              },
                            );
                            setState(() {
                              stateList.add(a);
                            });
                          }
                        }

                      },
                    ),
                    SizedBox(height: 5.0,),
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: stateList,
                      ),
                    ))
                  ],
                ),
              );

            });
        });
  }

  ShowCityPicker(BuildContext ctx,String statess){

    city = "";

    for(var x in citydatbase){
      if(x['state'] == statess){
        var citiesItem = ListTile(
          leading: Icon(Iconsax.building,color: mainColor,),
          title: Row(
            children: [
              mainText(x['city'], textColor, 15.0, FontWeight.normal, 1),
            ],
          ),
          onTap: (){
            super.setState(() {
              city = x['city'];
              isCity = true;
              place = "$city, $state";
              getEventbyCustomCity(place);
              citiesList = [];
              cityList = [];
            });
            Navigator.pop(context);
          },
        );
        super.setState(() {
          cityList.add(citiesItem);
          citiesList.add(x['city']);
        });
      }
    }


    showBarModalBottomSheet(context: ctx,
        builder: (context){
          return
            StatefulBuilder(builder: (BuildContext context,StateSetter setState){
              return Container(
                // height: 200.0,
                color: bgColor,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 36,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,

                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: mainColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "Cities",
                          counterText: "",
                          prefixIcon: Icon(Iconsax.search_favorite,color: mainColor,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: errorColor
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: errorColor
                              )
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: secColor
                              )
                          ),
                          border:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          )
                      ),

                      onChanged: (text){
                        setState(() {
                          cityList = [];
                        });
                        for(var i in citiesList){
                          if(i.toString().toUpperCase().contains(text.toUpperCase())){
                            var a = ListTile(
                              title: Row(
                                children: [
                                  mainText(i, textColor, 15.0, FontWeight.normal, 1),
                                  Spacer(),
                                ],
                              ),
                              leading: Icon(Iconsax.location,color: mainColor,),
                              onTap: (){
                                super.setState(() {
                                  city = i;
                                  place = "$city, $state";
                                  getEventbyCustomCity(place);
                                  isCity = true;
                                  citiesList = [];
                                  cityList = [];
                                });
                                Navigator.pop(context);
                              },
                            );
                            setState(() {
                              cityList.add(a);
                            });
                          }
                        }

                      },
                    ),
                    SizedBox(height: 5.0,),
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: cityList,
                      ),
                    ))
                  ],
                ),
              );

            });
        });
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
  Color bg;
  Color text;
  filterbtnss({Key? key,required this.title,required this.bg,required this.text}) : super(key: key);

  late _filterbtnssState stateoffilter;

  @override
  State<filterbtnss> createState() {
    stateoffilter = _filterbtnssState();
    return stateoffilter;
  }
}

class _filterbtnssState extends State<filterbtnss> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ElevatedButton(
        // child: Padding(
        //   padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: onlymainText(widget.title, widget.text, 10.0, FontWeight.normal, 1),
        // ),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(widget.bg),
            backgroundColor: MaterialStateProperty.all<Color>(widget.bg),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: widget.text,width: 1.0)))),
        onPressed: (){
          if(widget.bg == bgColor){
            setState(() {
              stateofEvents.setState(() {
                stateofEvents.applyfiler(true, widget.title);
              });
              widget.bg = mainColor;
              widget.text = Colors.white;
            });
          }
          else{
            setState(() {
              stateofEvents.setState(() {
                stateofEvents.applyfiler(false, widget.title);
              });
              widget.bg = bgColor;
              widget.text = mainColor;
            });
          }
        },
      ),
    );
  }
}



