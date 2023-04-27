
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

late _approveScreenState stateOfApprove;

class approveScreen extends StatefulWidget {
  List data;
  bool multiday;
  String eid;
  approveScreen({Key? key,required this.data,required this.multiday,required this.eid}) : super(key: key);

  @override
  State<approveScreen> createState() {
    stateOfApprove = _approveScreenState();
    return stateOfApprove;
  }
}

class _approveScreenState extends State<approveScreen> {
  bool isHide = false;

  List<userItem> allUser = [];
  List<userItem> allfinalUser = [];

  bool oneSelected = false;
  List approveIds = [];

  @override
  void initState() {
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
            if(!m['approve']) {
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
            if(!ap){
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
            Visibility(
              visible: oneSelected,
              child: Container(
                margin: EdgeInsets.only(right: 20.0,bottom: 20.0),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Iconsax.tick_circle,color: textColor,),
                  backgroundColor: mainColor,
                  onPressed: (){
                    // print(approveIds);
                    ConfirmApprove();
                  },
                ),
              ),
            ),
            loaderss(isHide, context),
            notFound(allUser.isEmpty, "Nothing Found", context),
          ],
        ),

      ),
    );
  }


  ConfirmApprove() async {
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
        title: new Text('Approve'),
        content: new Text('Approve ${approveIds.length} users'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              JustApprove();

            },
            child: new Text(
              'Approve',
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


  JustApprove(){
    int a = approveIds.length;
    int b = 0;
    setState(() {
      isHide = true;
    });
    for(var i in approveIds){
      b += 1;
      String id = i.toString().split("&")[0];
      String name = i.toString().split("&")[1];
      String img = i.toString().split("&")[2];
      oneapprove(id, name, img);
      for(var x in allUser){
        if(x.stateofuserItem.widget.data['id'] == id){
          x.stateofuserItem.setState(() {
            x.stateofuserItem.approved = true;
            x.stateofuserItem.bg = bgLight;
          });
        }
      }
      if(b == a){
        setState(() {
          isHide = false;
          approveIds = [];
          oneSelected = false;
          toaster("Users Approved");
        });

      }

    }
  }

  oneapprove(String id, String name, String img) async{
    if(widget.multiday){
      Map<String,dynamic> item = {
        'approve':true
      };

      final ref = FirebaseDatabase.instance.reference();
      ref.child('event').child(widget.eid).child('enrolled').child(id).update(item).then((value) => {

      });
    }
    else{
      Map<String,dynamic> item = {
        id:"${id}&approve&not&${name}&${img}"
      };

      final ref = FirebaseDatabase.instance.reference();
      ref.child('event').child(widget.eid).child('enrolled').update(item).then((value) => {
      });
    }
  }


}

class userItem extends StatefulWidget {
  Map data;
  bool multiday;
  String eid;
  userItem({Key? key,required this.data,required this.multiday,required this.eid}) : super(key: key);

  late _userItemState stateofuserItem;
  @override
  State<userItem> createState() {
    stateofuserItem = _userItemState();
    return stateofuserItem;
  }

}

class _userItemState extends State<userItem> {
  bool approved = false;
  Color bg = bgLight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        print("hello");
        if(!stateOfApprove.oneSelected){
          stateOfApprove.setState(() {
            stateOfApprove.oneSelected = true;
            stateOfApprove.approveIds.add("${widget.data['id']}&${widget.data['name']}&${widget.data['img']}");
          });
          setState(() {
            bg = secColor;
          });
        }
      },

      onTap: (){
        print("hey");
        if(stateOfApprove.oneSelected){
          if(bg == secColor){
            setState(() {
              bg = bgLight;
            });
            stateOfApprove.setState(() {
              stateOfApprove.approveIds.remove("${widget.data['id']}&${widget.data['name']}&${widget.data['img']}");
              if(stateOfApprove.approveIds.isEmpty){
                stateOfApprove.oneSelected = false;
              }
            });
          }
          else{
            setState(() {
              bg = secColor;
            });
            stateOfApprove.setState(() {
              stateOfApprove.approveIds.add("${widget.data['id']}&${widget.data['name']}&${widget.data['img']}");
              if(stateOfApprove.approveIds.isEmpty){
                stateOfApprove.oneSelected = false;
              }
            });
          }
        }
      },
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: bg,
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
                Visibility(visible:!approved,child: btnsss("APPROVE", () {approve();}, errorColor, textColor)),
                Visibility(visible:approved,child: btnsss("APPROVED", () { }, greenColor, textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  approve() async{
    setState(() {
      approved = true;
    });
    if(widget.multiday){
      Map<String,dynamic> item = {
        'approve':true
      };

      final ref = FirebaseDatabase.instance.reference();
      ref.child('event').child(widget.eid).child('enrolled').child(widget.data['id']).update(item).then((value) => {
        toaster("User Approved"),
      });
    }
    else{
      Map<String,dynamic> item = {
        widget.data['id']:"${widget.data['id']}&approve&not&${widget.data['name']}&${widget.data['img']}"
      };

      final ref = FirebaseDatabase.instance.reference();
      ref.child('event').child(widget.eid).child('enrolled').update(item).then((value) => {
        toaster("User Approved"),
      });
    }
  }
}

