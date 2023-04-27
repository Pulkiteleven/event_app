import 'package:event_app/Usefull/Buttons.dart';
import 'package:event_app/Auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Usefull/Colors.dart';
import '../Usefull/Functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';






final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String username = "";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mainText("Sign up", bgColor, 30.0, FontWeight.bold, 1),
                          SizedBox(
                            height: 50.0,
                          ),
                          mainText(" Username", textDark, 10.0, FontWeight.normal, 1),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            maxLength: 50,
                            style: TextStyle(
                                color: textDark,
                                fontSize: 13.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              filled: true,
                              counterText: "",
                              fillColor: lightGrey,
                              prefixIcon: Icon(Iconsax.user,color: textDark,),
                              hintText: "Username",
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
                            onChanged: (text) {
                              username = text;
                            },
                            validator: (value) {
                             if(value!.isEmpty){
                               return("Please enter Username");
                             }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),

                          mainText(" Email", textDark, 10.0, FontWeight.normal, 1),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 50,
                            style: TextStyle(
                                color: textDark,
                                fontSize: 13.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              filled: true,
                              counterText: "",
                              fillColor: lightGrey,
                              prefixIcon: Icon(Iconsax.user,color: textDark,),
                              hintText: "Email",
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
                            onChanged: (text) {
                              email = text;
                            },
                            validator: (value) {
                              bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (!emailValid) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          mainText(" Password", textDark, 10.0, FontWeight.normal, 1),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            maxLength: 18,
                            style: TextStyle(
                                color: textDark,
                                fontSize: 13.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              filled: true,
                              counterText: "",
                              fillColor: lightGrey,
                              prefixIcon: Icon(Iconsax.key,color: textDark,),
                              hintText: "Password",
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
                            onChanged: (text) {
                              password = text;
                            },
                            validator: (value) {
                              if(value!.isEmpty){
                                return("Please Enter a Password");
                              }
                              else if(value.length < 6){
                                return("Password Length must be more than 6 letters");
                              }
                            },
                          ),
                          SizedBox(
                            height: 5.0,
                          ),

                          SizedBox(
                            height: 30.0,
                          ),

                          fullbtnsss("Create", () {signup(context);}, bgColor, Colors.white),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          mainText("Alreday have an Account?", mainColor, 13.0,
                              FontWeight.normal, 1),
                          TextButton(
                              onPressed: () {
                                goLogin();
                              },
                              child: mainText("Login", secColor, 13.0,
                                  FontWeight.normal, 1)),
                          Spacer()
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            loaderss(isHide, context),
          ],
        ),
      ),
    );
  }

  void goLogin() {
    navScreen(logIn(), context, true);
  }

  void signup(BuildContext context) {
    if(formKey.currentState!.validate()){
      setState((){
        isHide = true;
      });
      FinalSignUp(context);
    }
  }

  FinalSignUp(BuildContext context) async{
    try{
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password)
          .then((value) => {
        print("blueee" + value.toString()),
        // postDetailstorealtime()
        postDetailsTofirestore(),
      });
    } on FirebaseAuthException catch(e){
      if(e.code == "email-already-in-use"){
        setState((){
          isHide = false;
          Snacker("User Already Exists", _messangerKey);
        });
      }
      else{
        isHide = false;
        Snacker("Something Went Wrong", _messangerKey);
      }
    }
  }
  postDetailsTofirestore() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    Map<String,String> item = {
      "name":username,
      "email":email,
      "uid":user!.uid,
    };



    await firestore.collection("user")
        .doc(user.uid)
        .set(item);
    setState((){
      isHide = false;
    });
    toaster("User created Succesfully");
    navScreen(logIn(), context, true);

  }



}
