import 'package:event_app/Usefull/Colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:iconsax/iconsax.dart';


class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    const String2 ='If you have any queries or suggestions about the application and its working, do not hesitate';
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
            mainTextFAQS("Contact Us", textColor, 20.0, FontWeight.bold, 10),
            SizedBox(height: 20.0,),
            mainTextFAQS(String2, textColor, 15.0, FontWeight.normal, 30),

          ],
        ),
      ),

    );
  }
}