
import 'package:event_app/Data/CityandStates.dart';
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


class enrollScreen extends StatefulWidget {
  List data;
  bool multiday;
  String eid;
  enrollScreen({Key? key,required this.data,required this.multiday,required this.eid}) : super(key: key);

  @override
  State<enrollScreen> createState() => _enrollScreenState();
}

class _enrollScreenState extends State<enrollScreen> {
  bool isHide = false;

  List<userItem> allUser = [];
  List<userItem> allfinalUser = [];


  @override
  void initState() {
    print(widget.data);
    populateItems();
  }

  populateItems() async{
    if(widget.multiday){
      for(var i in widget.data){
        var m = i as Map;
        if(m['id'] != "id"){
          Map p = {
            'id':m['id'],
            'name':m['name'],
            'img':m['img'],
            'approve':m['approve'],
            'attend':m['attend'],
          };

          var a = userItem(data: p,multiday: widget.multiday,eid: widget.eid,);

          setState(() {
            if(m['approve']) {
              allUser.add(a);
              allfinalUser.add(a);
            }
          });
        }
      }
    }
    else{
      for(var i in widget.data){
        var m = i.toString().split("&");
        if(m[0] != "id"){
          bool ap = false;
          bool ate = false;
          if(m[1] == "approve"){
            ap = true;
          }
          if(m[2] == "attend"){
            ate = true;
          }
          Map p = {
            'id':m[0],
            'approve':ap,
            'attend':ate,
            'name':m[3],
            'img':m[4],
          };

          setState(() {
            if(ap){
              allUser.add(userItem(data: p,multiday: widget.multiday,eid: widget.eid,));
              allfinalUser.add(userItem(data: p,multiday: widget.multiday,eid: widget.eid,));
            }
          });

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgLight,
          leading: IconButton(
              icon: Icon(Iconsax.arrow_left,color: textColor,),
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    height:40.0,
                    child: TextFormField(
                      maxLength: 36,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: textDark,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        counterText: "",
                        fillColor: lightGrey,
                        prefixIcon: Icon(Iconsax.search_normal,color: textDark,),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          fontFamily: 'mons',
                          fontSize: 13.0,

                          color: Colors.grey[500],
                        ),
                        errorStyle: TextStyle(
                          color: errorColor,
                          fontFamily: 'mons',
                          fontSize: 10.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor,width: 0),
                          borderRadius: BorderRadius.circular(20.0),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: textColor,
                              width: 0
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorColor,
                              width: 0
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),

                      onChanged: (text){
                        setState(() {
                          allUser = [];
                        });
                        for(var i in allfinalUser){
                          print(i.data['name'].toString().toUpperCase());
                          if(i.data['name'].toString().toUpperCase().contains(text.toUpperCase())){
                            setState(() {
                              allUser.add(i);
                            });
                          }
                        }

                      },
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Column(
                    children: allUser,
                  ),
                ],
              ),
            ),
            loaderss(isHide, context),
            notFound(allUser.isEmpty, "Nothing Found", context),
          ],
        ),

      ),
    );
  }
}

class userItem extends StatefulWidget {
  Map data;
  bool multiday;
  String eid;
  userItem({Key? key,required this.data,required this.multiday,required this.eid}) : super(key: key);

  @override
  State<userItem> createState() => _userItemState();
}

class _userItemState extends State<userItem> {
  bool approved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: bgLight,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Avatar(widget.data['img'], 25.0),
              SizedBox(width: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainText(widget.data['name'], textColor, 15.0, FontWeight.bold, 2),
                ],
              ),
              Spacer(),
            Icon(Iconsax.verify,color: greenColor,),
            //   Visibility(visible:!approved,child: btnsss("APPROVE", () {approve();}, errorColor, textColor)),
            //   Visibility(visible:approved,child: btnsss("APPROVED", () { }, greenColor, textColor)),
            ],
          ),
        ),
      ),
    );
  }

  // approve() async{
  //   setState(() {
  //     approved = true;
  //   });
  //   if(widget.multiday){
  //     Map<String,dynamic> item = {
  //       'approve':true
  //     };
  //
  //     final ref = FirebaseDatabase.instance.reference();
  //     ref.child('event').child(widget.eid).child('enrolled').child(widget.data['id']).update(item).then((value) => {
  //       toaster("User Approved"),
  //     });
  //   }
  //   else{
  //     Map<String,dynamic> item = {
  //       widget.data['id']:"${widget.data['id']}&approve&not&${widget.data['name']}&${widget.data['img']}"
  //     };
  //
  //     final ref = FirebaseDatabase.instance.reference();
  //     ref.child('event').child(widget.data['id']).child('enrolled').update(item).then((value) => {
  //       toaster("User Approved"),
  //     });
  //   }
  // }
}

