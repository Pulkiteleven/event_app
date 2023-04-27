import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_app/Auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/post.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';



navScreen(Widget a,BuildContext context,bool replace){
  if(replace){
    Navigator.pushReplacement(context,MaterialPageRoute(builder:
        (context){
      return a;
    }));
  }
  else {
    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context){
      return a;
    }));
    // Navigator.push(context,rootN MaterialPageRoute(builder:
    //     (context) {
    //   return a;
    // }));
  }
}


bottoms(BuildContext ctx, Widget w) {
  showBarModalBottomSheet(
      context: ctx,
      builder: (context) {
        return Container(
          // height: 200.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: w,
        );
      });
}



String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

LaunchIt(String _url) async{
  await launchUrl(Uri.parse(_url));
}
