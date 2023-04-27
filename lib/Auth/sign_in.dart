import 'package:event_app/Backend/backend.dart';
import 'package:event_app/Usefull/Buttons.dart';
import 'package:event_app/Auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';



import '../Usefull/Colors.dart';
import '../Usefull/Functions.dart';

String email = "";
String password = "";

final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class logIn extends StatefulWidget {
  logIn({Key? key}) : super(key: key);

  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool isHide = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 60.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                mainText("Sign in", bgColor, 30.0, FontWeight.bold, 1),
                                SizedBox(
                                  height: 50.0,
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
                                  height: 15.0,
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
                                Row(
                                  children: [
                                    Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          forgetPass();
                                        },
                                        child: mainText("Forget Password?", secColor, 13.0,
                                            FontWeight.normal, 1))
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                    fullbtnsss("Login", () {login(context);}, bgColor, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          mainText("Didn't have an Account?", textColor, 13.0,
                              FontWeight.normal, 1),
                          TextButton(
                              onPressed: () {
                                goSignUp();
                              },
                              child: mainText("Sign Up", textColor, 13.0,
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


  void forgetPass() {
  }

  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isHide = true;
      });
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          checker(context),
          setState(() {
            // isHide = false;
          }),
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          setState(() {
            isHide = false;

          });
          Snacker("User not Found", _messangerKey);
        } else if (e.code == "wrong_password") {
          setState(() {
            isHide = false;
          });
          Snacker("Wronng Password", _messangerKey);
          print('hello');

        } else {
          setState(() {
            isHide = false;
          });
          Snacker("Something went wrong", _messangerKey);
          print('hello');

        }
      }
    }
  }

  void goSignUp() {
    navScreen(signUp(), context, false);
  }
}
