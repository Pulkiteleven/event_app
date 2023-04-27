import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:event_app/Backend/backend.dart';
import 'package:event_app/Data/CityandStates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Usefull/Colors.dart';
import '../Usefull/Buttons.dart';

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

import 'package:http/http.dart' as http;

import '../Usefull/Functions.dart';
import 'package:draggable_home/draggable_home.dart';







class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

final databaseRef = FirebaseDatabase.instance.reference();

class _PostScreenState extends State<PostScreen> {
  bool isHide = false;
  String title = "";
  String desc = "";

  bool multiday = false;
  bool isDay = false;
  List multibg = [bgColor,bgColor];
  List multitext = [mainColor,mainColor];
  
  
  DateTime date = DateTime.now();
  String dateString = "Date";
  bool isDate = false;

  DateTime startDate = DateTime.now();
  String startDatestring = "From";
  bool isStartDate = false;


  DateTime endDate = DateTime.now();
  String endDateString = "To";
  bool isendDate = false;

  DateTime startTime = DateTime.now();
  String startTimeString = "Start Time";
  bool isStartTime = false;
  Time _startTime = Time(hour: 11, minute: 00);


  DateTime endTime = DateTime.now();
  String endTimeString = "End Time";
  bool isEndTime = false;
  Time _endTime = Time(hour: 11, minute: 00);


  bool online = false;
  String link = "";
  bool isType = false;
  List typebg = [bgColor,bgColor];
  List typetext = [mainColor,mainColor];

  String city = "";
  String state = "";
  String place = "Select City";
  bool isCity = false;
  String venu = "";

  int totalSeats = 0;

  bool paid = false;
  int price = 0;


  final formKey = GlobalKey<FormState>();

  List<Widget> stateList = [];
  List<Widget> cityList = [];
  List citiesList = [];
  String number = "";


  bool isCategory = false;
  String category = "";
  List<categoryItem> categoryList = [];

  List categroyBg = [];
  List categroyBgStock = [];
  List categroyText = [];
  List categroyTextStock = [];

  String bannerImg = "";
  int currentIndex = 0;
  File bannerFile = File("");
  List<Widget> allBanners = [];
  bool isbannerFile = false;

  bool canpost = false;

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

   bool approval = false;
   bool isApproved = false;
   List approvebg = [bgColor,bgColor];
   List approvetext = [mainColor,mainColor];


  @override
  void initState() {
    super.initState();
    getCategory();
    putBanners();
    getPosters();
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
          categroyBg.add(bgColor);
          categroyBgStock.add(bgColor);
          categroyText.add(mainColor);
          categroyTextStock.add(mainColor);

          var a = categoryItem(title:i.toString().toUpperCase(),
              callback:() {selectCategory(category.indexOf(i), i); },
              bg:categroyBg[category.indexOf(i)],
              text:categroyText[category.indexOf(i)]);
          var s = SizedBox(width: 5.0,);

          setState(() {
            categoryList.add(a);
            // isHide = false;
          });
        }
      }
    }
  }

  getPosters() async {
    setState(() {
      isHide = true;
    });
    User? user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('posters')
        .get();

    if (querySnapshot != null) {
      final allData = querySnapshot.docs.map((e) => e.data()).toList();
      if (allData.length != 0) {
        var b = allData[0] as Map<String, dynamic>;
        print(b);
        List posters = b['posters'];
        String? email = user!.email;
        if(posters.contains(email)){
          setState(() {
            canpost = true;
            isHide= false;
          });
        }
        else{
          setState(() {
            canpost = false;
            isHide = false;
          });
        }
        
      }
    }
  }

  selectCategory(int a, String s){
    setState(() {
      for(var i in categoryList){
        setState(() {
          if(s.toUpperCase() == i.title){
            i.stateOfCategory.setState(() {
              i.stateOfCategory.widget.bg = mainColor;
              i.stateOfCategory.widget.text = Colors.white;
              category = s;
              isCategory = true;
            });

          }
          else {
            i.stateOfCategory.setState(() {
              i.stateOfCategory.widget.bg = bgColor;
              i.stateOfCategory.widget.text = mainColor;
            });
          }
        });
      }



    });
  }


  putBanners(){
    for(int i = 0;i<=8;i++){
      var a = GestureDetector(
        onTap: (){
          setState(() {
            currentIndex = i;
            bannerFile = File("");
          });
        },
        child: banners(i, "", "", 100.0,15.0,context),
      );
      var s = SizedBox(width: 5.0,);
      
      setState(() {
        allBanners.add(a);
        allBanners.add(s);
      });
      
    }
  }

  customBanner() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      print(file.path);
      cropSquare(File(pickedFile.path), context);
      // uploadFile(file.path, context);
    }
  }

  Future cropSquare(File imageFile, BuildContext context) async {
    CroppedFile? a = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 512, ratioY: 200),
        aspectRatioPresets: [CropAspectRatioPreset.square]);

    setState(() {
      bannerFile = File(a!.path);
      print(a.path);
    });
  }

  late BuildContext mCtx;


  @override
  Widget build(BuildContext context) {

    mCtx = context;
    return DraggableHome(
      title: mainText("", textColor, 10.0, FontWeight.normal, 1),
      alwaysShowLeadingAndAction: true,
      backgroundColor: bgLight,

      actions: [
        IconButton(
            onPressed: (){
              customBanner();
            },
            icon: Icon(Iconsax.edit,color: Colors.white,)),
      ],
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left,color: textColor,),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      headerExpandedHeight: 0.25,
      stretchMaxHeight: 0.27,
      appBarColor: bgLight,
      headerWidget:banners(currentIndex, bannerImg, bannerFile.path, MediaQuery.of(context).size.width,15.0,context),

      body: [Visibility(
        visible: canpost && !isHide,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: allBanners,
                            ),
                          ),

                          TextFormField(
                            maxLength: 50,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 25.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Post Event",
                              hintStyle: TextStyle(
                                fontFamily: 'mons',
                                fontSize: 25.0,
                                color: lightGrey,
                              ),
                              errorStyle: TextStyle(
                                color: errorColor,
                                fontFamily: 'mons',
                                fontSize: 10.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: errorColor,width: 0),

                              ),
                            ),
                            onChanged: (text){
                              setState(() {
                                title = text;
                              });
                            },
                            validator: (text){
                              if(text!.isEmpty){
                                return("Please Enter a Title");
                              }
                            },

                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 200,
                            style: TextStyle(
                                color: lightGrey,
                                fontSize: 15.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Tell us more about the Event",
                              hintStyle: TextStyle(
                                fontFamily: 'mons',
                                fontSize: 15.0,
                                color: lightGrey,
                              ),
                              errorStyle: TextStyle(
                                color: errorColor,
                                fontFamily: 'mons',
                                fontSize: 10.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: errorColor,width: 0),

                              ),
                            ),
                            onChanged: (text){
                              setState(() {
                                desc = text;
                              });
                            },
                            validator: (text){
                              if(text!.isEmpty){
                                return("Please Enter a Desc");
                              }
                            },
                          ),

                          SizedBox(height: 15.0,),

                          mainText("The event is?", lightGrey, 10.0, FontWeight.normal, 1),
                          Row(
                            children: [
                              Expanded(child: selectbtnsss("Single Day Event", () { changeMulti(0);}, multibg[0], multitext[0])),
                              SizedBox(width: 5.0,),
                              Expanded(child: selectbtnsss("Multi Day Event", () { changeMulti(1);}, multibg[1], multitext[1])),
                            ],
                          ),
                          SizedBox(height: 10.0,),


                          Visibility(
                              visible: isDay && !multiday,
                              child: selectbtnsss(dateString,(){pickDate();},bgColor,mainColor)),
                          Visibility(
                              visible: isDay && multiday,
                              child: Row(
                                children: [
                                  Expanded(child: selectbtnsss(startDatestring,(){pickstartDate();},bgColor,mainColor)),
                                  SizedBox(width: 5.0,),
                                  Expanded(child: selectbtnsss(endDateString,(){pickendDate();},bgColor,mainColor)),
                                ],
                              )),
                          SizedBox(height: 10.0,),

                          mainText("event time", lightGrey, 10.0, FontWeight.normal, 1),
                          Row(
                            children: [
                              Expanded(child: selectbtnsss(startTimeString, () { startTimePicker();}, bgColor, mainColor)),
                              SizedBox(width: 5.0,),
                              Expanded(child: selectbtnsss(endTimeString, () { endTimePicker();}, bgColor, mainColor)),
                            ],
                          ),

                          SizedBox(height: 10.0,),
                          mainText("Online or Offline?", lightGrey, 10.0, FontWeight.normal, 1),
                          Row(
                            children: [
                              Expanded(child: selectbtnsss("Online", () {changeType(0);}, typebg[0], typetext[0])),
                              SizedBox(width: 5.0,),
                              Expanded(child: selectbtnsss("Offline", () {changeType(1);}, typebg[1], typetext[1])),
                            ],
                          ),



                          SizedBox(height: 10.0,),

                          Visibility(
                            visible: isType && online,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              maxLength: 200,
                              style: TextStyle(
                                  color: lightGrey,
                                  fontSize: 15.0,
                                  fontFamily: 'mons'),
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "link",
                                hintStyle: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color: lightGrey,
                                ),
                                errorStyle: TextStyle(
                                  color: errorColor,
                                  fontFamily: 'mons',
                                  fontSize: 10.0,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: textColor,width: 0),

                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: textColor,width: 0),

                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: errorColor,width: 0),

                                ),
                              ),
                              onChanged: (text){
                                setState(() {
                                  link = text;
                                });
                              },
                              validator: (text){
                                if(text!.isEmpty){
                                  return("Please Enter a Link");
                                }
                              },
                            ),
                          ),

                          Visibility(
                              visible: isType && !online,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mainText("Where?", lightGrey, 10.0, FontWeight.normal, 1),
                                  selectbtnsss(place, () { ShowStateCityPicker(context);}, bgColor, mainColor),
                                  SizedBox(height: 5.0,),
                                  TextFormField(
                                    minLines: 1,
                                    maxLines: 2,
                                    maxLength: 200,
                                    style: TextStyle(
                                        color: lightGrey,
                                        fontSize: 13.0,
                                        fontFamily: 'mons'),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Where event is talking place?",
                                      hintStyle: TextStyle(
                                        fontFamily: 'mons',
                                        fontSize: 13.0,
                                        color: lightGrey,
                                      ),
                                      errorStyle: TextStyle(
                                        color: errorColor,
                                        fontFamily: 'mons',
                                        fontSize: 10.0,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: textColor,width: 0),

                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: textColor,width: 0),

                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: errorColor,width: 0),

                                      ),
                                    ),
                                    onChanged: (text){
                                      setState(() {
                                        venu = text;
                                      });
                                    },
                                    validator: (text){
                                      if(text!.isEmpty){
                                        return("Please Enter a Venu");
                                      }
                                    },
                                  ),

                                ],
                              )),

                          SizedBox(height: 10.0,),
                          TextFormField(
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: lightGrey,
                                fontSize: 15.0,
                                fontFamily: 'mons'),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Capacity",
                              hintStyle: TextStyle(
                                fontFamily: 'mons',
                                fontSize: 15.0,
                                color: lightGrey,
                              ),
                              errorStyle: TextStyle(
                                color: errorColor,
                                fontFamily: 'mons',
                                fontSize: 10.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textColor,width: 0),

                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: errorColor,width: 0),

                              ),
                            ),
                            onChanged: (text){
                              setState(() {
                                totalSeats = int.parse(text);
                              });
                            },
                            validator: (text){
                              if(text!.isEmpty){
                                return("Please Enter Total Seats");
                              }
                            },
                          ),
                          SizedBox(height: 10.0,),
                          mainText("Category", lightGrey, 10.0, FontWeight.normal, 1),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categoryList,
                            ),
                          ),
                          SizedBox(height: 15.0,),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              mainText("Approval Required", lightGrey, 15.0, FontWeight.normal, 1),
                              SizedBox(width: 5.0,),
                              Expanded(child:
                              selectbtnsss("Yes", () { changeApproval(0);}, approvebg[0], approvetext[0])),
                              SizedBox(width: 3.0,),
                              Expanded(child: selectbtnsss("No", () { changeApproval(1);}, approvebg[1], approvetext[1])),
                            ],
                          ),

                          SizedBox(height: 15.0,),
                          Container(
                              height: 70.0,
                              child: fullbtnsss("POST EVENT", () {postNow();}, mainColor, textColor)),
                        ]),
                  )),
            ),
            loaderss(isHide, context)
          ],
        ),
      ),
        Center(
          child: Visibility(
              visible: !canpost && !isHide,
              child: sorry("You Dont have the Permission to Post an Event",TextButton(onPressed: (){
                toaster("hello");
              }, child: mainText("Contact Support", textColor, 15.0, FontWeight.normal, 1)))),
        )
      ],
    );
  }

  postNow(){
    // postFinalData("");
    if(formKey.currentState!.validate()){
      if(!isDay){
        snacker("Please Select Event Days", mCtx);
      }
      else if(!isDate && !multiday){
        snacker("Please Select Event Date", mCtx);
      }
      else if(!isStartDate && multiday){
        snacker("Please Select Event Start Date", mCtx);
      }
      else if(!isendDate && multiday){
        snacker("Please Select Event End Date", mCtx);
      }
      else if(!isStartTime){
        snacker("Please Select Event Start Time", mCtx);
      }
      else if(!isType){
        snacker("Please Select Event is Online or Offline", mCtx);
      }
      else if(!isCity && !online){
        snacker("Please Select Event City", mCtx);
      }
      else if(!isCategory){
        snacker("Please Select Event Category", mCtx);
      }
      else if(!isApproved){
        snacker("Please Select Approval Type", mCtx);
      }
      else{
        UploadPhoto(bannerFile.path);
      }
    }
  }

  UploadPhoto(String file) async{
    setState((){
      isHide = true;
    });
    if(file != "") {
      String url = "https://api.imgbb.com/1/upload?key=2c603ad4d5a3be453e36628616d29057";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(http.MultipartFile('image',
          File(file).readAsBytes().asStream(), File(file).lengthSync(),
          filename: file
              .split("/")
              .last
      ));
      // var response = await request.send();
      http.Response response = await http.Response.fromStream(await request.send());

      // print(response.headers);
      print(response.body);
      Map responseData = json.decode(response.body);
      String imgUrl = responseData['data']['url'];
      postFinalData(imgUrl);
      // print(await response.stream.bytesToString());

    }
    else{
      setState((){
        isHide = true;
      });
      postFinalData("");
    }
  }

  postFinalData(String imgUrl){

    if(online){
      place = "online";
    }

    late var m;
    if(multiday){
      m = {
        'id':'id',
        'approve':false,
        'attend':{
          'id':'id',
        }
      };
    }
    else{
      m = "id&a&a&a&a";
    }

    print("batman");
    FirebaseAuth auth = FirebaseAuth.instance;

    String key = generateRandomString(15);
    Map<String, dynamic> Item = {
      'title':title,
      'desc':desc,
      'id':key,
      'multiday':multiday,
      'date':date.toString(),
      'startDate':startDate.toString(),
      'endDate':endDate.toString(),
      'sartTime':startTimeString,
      'endTime':endTimeString,
      'online':online,
      'link':link,
      'approve':approval,
      'enrolled':{
        'id':m,
      },
      'attend':{
        'id':'id'
      },
      'city': place,
      'venu':venu,
      'capacity':totalSeats,
      'category':category,
      'index':currentIndex,
      'from': auth.currentUser!.uid,
      'img':imgUrl
    };

    Map<String, dynamic> mainItem = {key:Item};

      final ref = FirebaseDatabase.instance.reference();
      ref.child('event').update(mainItem).then((value) =>
      {
        postToCategory(key, category)
      });


  }

  postToCategory(String id,String cat) async{
    Map<String,dynamic> item = {
      id:id
    };

    final ref = FirebaseDatabase.instance.reference();
    ref.child('category').child(cat).update(item).then((value) => {
      puttoUser(id)
    });
  }

  changeApproval(int a){
    setState(() {
      approvebg = [bgColor,bgColor];
      approvetext = [mainColor,mainColor];
      approvebg[a] = mainColor;
      approvetext[a] = textColor;
      isApproved = true;
    });
    if(a == 0){
      approval = true;
    }
    else{
      approval = false;
    }
  }

  puttoUser(String id) async{
    Map<String,dynamic> item = {
      id:id
    };

    User? user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseDatabase.instance.reference();
    ref.child('userEvent').child(user!.uid).update(item).then((value) => {
      setState((){
        puttoCity(id);
      })
    });
  }

  puttoCity(String id){

      Map<String, dynamic> item = {
        id: id
      };

      final ref = FirebaseDatabase.instance.reference();
      ref.child('cityEvent').child(place).update(item).then((value) =>
      {
        setState(() {
          toaster("Event Posted Successfully");
          checker(context);
        })
      });

  }



  startTimePicker() async {
    Navigator.push(
        context,
        showPicker(
            context: context,
            value: _startTime,
            onChange: (times) {
              setState(
                    () {
                  _startTime = times;
                },
              );
            },
            onChangeDateTime: (dateTime) {
              setState(() {
                startTimeString = DateFormat('HH:mm').format(dateTime).toString();
                isStartTime = true;
              });
            },
            // minuteInterval: MinuteInterval.FIVE
           ));
  }

  endTimePicker() async {
    if(isStartTime) {
      Navigator.push(
          context,
          showPicker(
            context: context,
            value: _endTime.replacing(
                hour: _startTime.hour, minute: _startTime.minute),
            onChange: (times) {
              setState(
                    () {
                  _endTime = times;
                },
              );
            },
            onChangeDateTime: (dateTime) {
              setState(() {
                endTimeString = DateFormat('HH:mm').format(dateTime).toString();
                isEndTime = true;
              });
            },
            // minuteInterval: MinuteInterval.FIVE
          ));
    }
    else{
      toaster("Please Select a Start Time");
    }
  }


  changeMulti(int a){
    setState(() {
      multibg = [bgColor,bgColor];
      multitext = [mainColor,mainColor];
      
      multibg[a] = mainColor;
      multitext[a] = textColor;
      isDay = true;
      if(a == 0){
        multiday = false;
      }
      else{
        multiday = true;
      }
    });
  }

  changeType(int a){
    setState(() {
      typebg = [bgColor,bgColor];
      typetext = [mainColor,mainColor];

      typebg[a] = mainColor;
      typetext[a] = textColor;
      isType = true;
      if(a == 0){
        online = true;
      }
      else{
        online = false;
      }
    });
  }

  void pickDate() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2030),
        currentTime: DateTime.now(),
        onChanged: (date) {
          if (date != null) {
            print(date);
          }
        },
        onConfirm: (datee){
          if (date != null) {
            String formattedDob = DateFormat('EEE dd MMM yyyy').format(datee);
            setState(() {
              date = datee;
              dateString = formattedDob;
              isDate = true;
            });
          }
        });
  }

  void pickstartDate() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2030),
        currentTime: DateTime.now(),
        onChanged: (date) {
          if (date != null) {
            print(date);
          }
        },
        onConfirm: (date){
          if (date != null) {
            String formattedDob = DateFormat('EEE dd MMM yyyy').format(date);
            setState(() {
              startDatestring = formattedDob;
              isStartDate = true;
              startDate = date;
            });
          }
        });
  }

  void pickendDate() async {
    if (isStartDate) {
      DatePicker.showDatePicker(context,
          showTitleActions: true,
          minTime: startDate.add(Duration(days: 1)),
          maxTime: DateTime(2030),
          currentTime: startDate.add(Duration(days: 1)),
          onChanged: (date) {
            if (date != null) {
              print(date);
            }
          },
          onConfirm: (date){
            if (date != null) {
              String formattedDob = DateFormat('EEE dd MMM yyyy').format(date);
              setState(() {
                endDateString = formattedDob;
                isendDate = true;
                endDate = date;
              });
            }
          });
    }
  else{
    toaster("Please Select a Start Date");
  }
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
            mainText(i, textColor, 15.0, FontWeight.normal, 1),
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
                color: bgColor,
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
                                  mainText(i, textColor, 15.0, FontWeight.normal, 1),
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
              mainText(x['city'], textColor, 15.0, FontWeight.normal, 1),
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
                color: bgColor,
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
                                  mainText(i, textColor, 15.0, FontWeight.normal, 1),
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

class categoryItem extends StatefulWidget {
  String title;
  Color bg;
  Color text;
  VoidCallback callback;
  categoryItem({Key? key,required this.title,required this.bg,required this.text,required this.callback}) : super(key: key);

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
          child: Row(
            children: [
              mainText(widget.title, widget.text, 13.0, FontWeight.normal, 1),
            ],
          ),
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
        onPressed: widget.callback,
      ),
    );
  }
}

