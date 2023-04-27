import 'package:event_app/Usefull/Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    const String1 = 'Ibento is an event management platform developed by ASPER, a team of enthusiastic designers and developers. This app allows users to create, share, find and attend events that fuel their passions and enrich their lives. Seamless planning for all kinds of forums from workshops, bootcamps, to community conferences, as well as contests.\n\n'
        'Our focus is to elevate your events from ordinary to extraordinary with the touch of a button and assist people in locating all types of happenings at one location, effortlessly.\n\n'
        'Our mission is to bring people together as a social network so they can discover and share events that align with their interests.';
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation:0,
          backgroundColor:Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left_2,color: Colors.white,),
        ),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mainTextFAQS("About Us", textColor, 20.0, FontWeight.bold, 10),
            SizedBox(height: 20.0,),
            mainTextFAQS(String1, textColor, 15.0, FontWeight.normal, 30),
          ],
        ),
      ),

    );
  }
}