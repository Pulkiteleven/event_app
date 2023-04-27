import 'package:event_app/Usefull/Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';



class myQR extends StatefulWidget {
  String text;
  String qrs;
  myQR({Key? key,required this.text,required this.qrs}) : super(key: key);

  @override
  State<myQR> createState() => _myQRState();
}

class _myQRState extends State<myQR> {
  bool isHide = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = "";
  @override
  void initState() {
    setState(() {
      uid = auth.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Iconsax.arrow_left,color: textColor,),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        QrImage(
                          foregroundColor: textColor,
                          data: widget.qrs,
                          version: QrVersions.auto,
                          size: 300.0,
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    mainText(widget.text, textColor, 20.0, FontWeight.bold, 3),
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
