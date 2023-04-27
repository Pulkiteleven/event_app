
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Event/MyQR.dart';
import 'package:event_app/Event/OneEvent.dart';
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


class loadEvent extends StatefulWidget {
  String id;
  Map userData;
  loadEvent({Key? key,required this.id,required this.userData}) : super(key: key);

  @override
  State<loadEvent> createState() => _loadEventState();
}

class _loadEventState extends State<loadEvent> {

  @override
  void initState() {
    getEventswithId(widget.id);
  }

  getEventswithId(String id) async {
    var ref = await FirebaseDatabase.instance.reference().child('event');
    await ref.child(id).onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic,dynamic>;
        print(data);
        navScreen(oneEvent(data: data,userData: widget.userData,), context, true,);
      }
      else{
        toaster("Invalid QR");
        Navigator.pop(context);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            loaderss(true, context),
          ],
        )
      ),
    );
  }


}
