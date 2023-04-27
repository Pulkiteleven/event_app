
import 'package:event_app/Data/CityandStates.dart';
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



class alooDart extends StatefulWidget {
  Widget data;
  alooDart({Key? key,required this.data}) : super(key: key);

  @override
  State<alooDart> createState() => _alooDartState();
}

class _alooDartState extends State<alooDart> {






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Iconsax.arrow_left,color: textColor,),
          ),
        ),
        backgroundColor: bgColor,
        body: widget.data,
      ),
    );
  }


}
