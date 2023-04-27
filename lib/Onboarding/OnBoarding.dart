
import 'package:event_app/Backend/backend.dart';
import 'package:event_app/Data/CityandStates.dart';
import 'package:event_app/Usefull/Buttons.dart';
import 'package:event_app/Usefull/Colors.dart';
import 'package:event_app/Usefull/Functions.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



late _onBoardingState stateofOnboarding;


class onBoarding extends StatefulWidget {
  const onBoarding({Key? key}) : super(key: key);

  @override
  State<onBoarding> createState() {
    stateofOnboarding = _onBoardingState();
    return stateofOnboarding;
  }
}

class _onBoardingState extends State<onBoarding> {

  List<PageViewModel> onboardingPages = [];
  List interstList = [];
  String index = "";
  String place = "";
  late BuildContext mCtx;
  bool isHide = false;

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    setState((){
      index = _auth.currentUser!.uid;
      populateScreen();
    });
  }

  populateScreen() {
    setState(() {
      onboardingPages = [
      PageViewModel(
          titleWidget: mainText("Select Your City", textColor, 35.0, FontWeight.bold, 1),
          bodyWidget:  StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
            return Column(
              children: [
                cityItem()
              ],
            );
          }),
          image: Icon(Iconsax.building_3,color: textColor,size: 100.0,),
          decoration: PageDecoration(
              imageFlex: 3,
              bodyFlex: 2,
              imagePadding: EdgeInsets.only(bottom: 0)
          )
      ),
      PageViewModel(
          titleWidget: mainText("Select Your Interests", textColor, 35.0, FontWeight.bold, 1),
          bodyWidget: myInterests(),
          image: Icon(Iconsax.like_1,color: textColor,size: 100.0,),
          decoration: PageDecoration(
              imageFlex: 3,
              bodyFlex: 2,
              imagePadding: EdgeInsets.only(bottom: 0)
          )
      ),
      PageViewModel(
          titleWidget: mainText("Select Your Avatar", textColor, 35.0, FontWeight.bold, 1),
          bodyWidget: allAvatars(),
          image: circleImg(id:_auth.currentUser!.uid),
          decoration: PageDecoration(
              imageFlex: 3,
              bodyFlex: 2,
              imagePadding: EdgeInsets.only(bottom: 0)
          )
      ),
    ];
    });
  }



  @override
  Widget build(BuildContext context) {

    mCtx = context;

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
        home:Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Stack(
              children: [
                IntroductionScreen(

                  globalBackgroundColor: bgColor,
                  pages: onboardingPages,
                  dotsDecorator: DotsDecorator(
                    activeColor: mainColor,
                  ),
                  showNextButton: true,
                  showBackButton: true,
                  next: mainText("Next", mainColor, 13.0, FontWeight.normal, 1),
                  back: mainText("Previous", mainColor, 13.0, FontWeight.normal, 1),
                  done: mainText("Done", mainColor, 13.0, FontWeight.normal, 1),
                  onDone: (){
                    Done();
                  },
                  onChange: (i){
                    print(i);
                  },
                ),
                loaderss(isHide, context),
              ],
            ),
          ),
        )
    );
  }

  Done(){
    if(place == ""){
      Snacker("Please Select Your City",_messangerKey);
    }
    else if(interstList.isEmpty){
      Snacker("Please Select Your Interests", _messangerKey);
    }
    else {
      posttoFireStore();
    }
  }

  posttoFireStore() async{
    setState(() {
      isHide = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    Map<String,dynamic> item = {
      "city":place,
      "cat":interstList,
      "index":index,
    };

    await firestore.collection("user")
    .doc(user!.uid)
    .update(item);

    toaster("Profile Completed Successfully");
    checker(context);


  }

}

class cityItem extends StatefulWidget {
  const cityItem({Key? key}) : super(key: key);

  @override
  State<cityItem> createState() => _cityItemState();
}

class _cityItemState extends State<cityItem> {
  String place = "Select City";
  bool isCity = false;
  String city = "";
  String state = "";
  List<Widget> stateList = [];
  List<Widget> cityList = [];
  List citiesList = [];

  @override
  Widget build(BuildContext context) {
    return selectbtnsss(place, () {
      ShowStateCityPicker(context);
    }, bgColor, mainColor);
  }

  ShowStateCityPicker(BuildContext ctx){

    state = "";
    super.setState(() {
      citiesList = [];
    });
    for(var i in allStates){
      var a = ListTile(
        title: Row(
          children: [
            mainText(i, textDark, 15.0, FontWeight.normal, 1),
            Spacer(),
          ],
        ),
        leading: Icon(Iconsax.map,color: mainColor,),
        onTap: (){
          state = i;
          Navigator.pop(context);
          ShowCityPicker(context,i);
        },
      );
      setState(() {
        stateList.add(a);
      });
    }

    showBarModalBottomSheet(context: ctx,
        builder: (context){
          return
            StatefulBuilder(builder: (BuildContext context,StateSetter setState){
              return Container(
                // height: 200.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 36,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,

                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: mainColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "State",
                          counterText: "",
                          prefixIcon: Icon(Iconsax.search_favorite,color: mainColor,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: errorColor
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: errorColor
                              )
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: secColor
                              )
                          ),
                          border:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          )
                      ),

                      onChanged: (text){
                        setState(() {
                          stateList = [];
                        });
                        for(var i in allStates){
                          if(i.toString().toUpperCase().contains(text.toUpperCase())){
                            var a = ListTile(
                              title: Row(
                                children: [
                                  mainText(i, textDark, 15.0, FontWeight.normal, 1),
                                  Spacer(),
                                ],
                              ),
                              leading: Icon(Iconsax.map,color: mainColor,),
                              onTap: (){
                                state = i;
                                Navigator.pop(context);
                                ShowCityPicker(context,i);
                              },
                            );
                            setState(() {
                              stateList.add(a);
                            });
                          }
                        }

                      },
                    ),
                    SizedBox(height: 5.0,),
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: stateList,
                      ),
                    ))
                  ],
                ),
              );

            });
        });
  }

  ShowCityPicker(BuildContext ctx,String statess){

    city = "";

    for(var x in citydatbase){
      if(x['state'] == statess){
        var citiesItem = ListTile(
          leading: Icon(Iconsax.building,color: mainColor,),
          title: Row(
            children: [
              mainText(x['city'], textDark, 15.0, FontWeight.normal, 1),
            ],
          ),
          onTap: (){
            super.setState(() {
              city = x['city'];
              isCity = true;
              place = "$city, $state";
              citiesList = [];
              cityList = [];
            });
            stateofOnboarding.setState(() {
              stateofOnboarding.place = place;
            });
            Navigator.pop(context);
          },
        );
        super.setState(() {
          cityList.add(citiesItem);
          citiesList.add(x['city']);
        });
      }
    }


    showBarModalBottomSheet(context: ctx,
        builder: (context){
          return
            StatefulBuilder(builder: (BuildContext context,StateSetter setState){
              return Container(
                // height: 200.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 36,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,

                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: mainColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "Cities",
                          counterText: "",
                          prefixIcon: Icon(Iconsax.search_favorite,color: mainColor,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: errorColor
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: errorColor
                              )
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: secColor
                              )
                          ),
                          border:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(

                                  color: mainColor
                              )
                          )
                      ),

                      onChanged: (text){
                        setState(() {
                          cityList = [];
                        });
                        for(var i in citiesList){
                          if(i.toString().toUpperCase().contains(text.toUpperCase())){
                            var a = ListTile(
                              title: Row(
                                children: [
                                  mainText(i, textDark, 15.0, FontWeight.normal, 1),
                                  Spacer(),
                                ],
                              ),
                              leading: Icon(Iconsax.location,color: mainColor,),
                              onTap: (){
                                super.setState(() {
                                  city = i;
                                  place = "$city, $state";
                                  isCity = true;
                                  citiesList = [];
                                  cityList = [];
                                });
                                Navigator.pop(context);
                              },
                            );
                            setState(() {
                              cityList.add(a);
                            });
                          }
                        }

                      },
                    ),
                    SizedBox(height: 5.0,),
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: cityList,
                      ),
                    ))
                  ],
                ),
              );

            });
        });
  }
}


class myInterests extends StatefulWidget {
  const myInterests({Key? key}) : super(key: key);

  @override
  State<myInterests> createState() => _myInterestsState();
}

class _myInterestsState extends State<myInterests> {
  bool isHide = false;
  List<categoryItem> allInerests = [];
  

  @override
  void initState() {
    getCategory();
  }

  getCategory() async {
    setState(() {
      isHide = true;
    });
    User? user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('category')
        .get();

    if (querySnapshot != null) {
      final allData = querySnapshot.docs.map((e) => e.data()).toList();
      if (allData.length != 0) {
        var b = allData[0] as Map<String, dynamic>;
        print(b);
        List category = b['category'];
        for(var i in category){
          var a = categoryItem(title: i, bg: bgColor, text: mainColor);

          setState(() {
            allInerests.add(a);
            isHide = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isHide,
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        ),
        Wrap(
          runSpacing: 2.0,
          spacing: 3.0,
          children: allInerests,
        )
      ],
    );
  }

}

class categoryItem extends StatefulWidget {
  String title;
  Color bg;
  Color text;
  categoryItem({Key? key,required this.title,required this.bg,required this.text}) : super(key: key);

  late _categoryItemState stateOfCategory;

  @override
  State<categoryItem> createState() {
    stateOfCategory = _categoryItemState();
    return stateOfCategory;
  }
}

class _categoryItemState extends State<categoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: mainText(widget.title, widget.text, 13.0, FontWeight.normal, 1),
        ),
        style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(widget.bg),
            backgroundColor:
            MaterialStateProperty.all<Color>(widget.bg),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: widget.text, width: 2.0)))),
        onPressed: (){
          if(stateofOnboarding.interstList.contains(widget.title)){
            setState(() {
              widget.bg = bgColor;
              widget.text = mainColor;
            });
            stateofOnboarding.setState(() {
              stateofOnboarding.interstList.remove(widget.title);
            });
          }
          else{
            setState(() {
              widget.bg = mainColor;
              widget.text = Colors.white;
            });
            stateofOnboarding.setState(() {
              stateofOnboarding.interstList.add(widget.title);
            });
          }
        },
      ),
    );
  }
}

class allAvatars extends StatefulWidget {
  const allAvatars({Key? key}) : super(key: key);

  @override
  State<allAvatars> createState() => _allAvatarsState();
}

class _allAvatarsState extends State<allAvatars> {
  List<Widget> allBottomAvatars = [];

  @override
  void initState() {
    for(int i = 0;i<20;i++){
      String str = generateRandomString(8);
      var a = GestureDetector(
        onTap: (){
          stateofcircleImg.setState(() {
            stateofcircleImg.widget.id = str;
          });
          stateofOnboarding.setState(() {
            stateofOnboarding.index = str;
          });
        },
        child: Avatar(str, 40.0),
      );
      var s = SizedBox(width: 5.0,);
      setState(() {
        allBottomAvatars.add(a);
        allBottomAvatars.add(s);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allBottomAvatars,
      ),
    );
  }
}

late _circleImgState stateofcircleImg;

class circleImg extends StatefulWidget {
  String id;
  circleImg({Key? key,required this.id}) : super(key: key);

  @override
  State<circleImg> createState() {
    stateofcircleImg = _circleImgState();
    return stateofcircleImg;
  }
}

class _circleImgState extends State<circleImg> {
  @override
  Widget build(BuildContext context) {
    return Avatar(widget.id, 70.0);
  }
}




