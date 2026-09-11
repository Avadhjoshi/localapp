import 'dart:async';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:localapp/CityDetailScreen.dart';
import 'package:localapp/models/UserCategory.dart';

import 'CategoryScreen.dart';
import 'CityScreen.dart';
import 'HomeScreen.dart';
import 'JobScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'constants/Config.dart';

import 'package:http/http.dart' as http;


class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int selectedIdx = -1;
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);

  List<String> items = [
    "News",
    "Jobs",
    "Buy Sell Rent",
    "Pune Clubs",
    "Offers"
  ];

  List user_category_data = [];
  List<User_Category_list> user_category_string = [];

  void selectItem(int index) {
    setState(() {
      if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));

      }
      if(index==1)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  JobScreen()));

      }
      if(index==2)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostScreen()));

      }
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = -1;
      } else {
        selectedIdx = index;
      }
    });
  }

  final List<String> imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];
  List<String> items_2 = ["#all", "#crime", "#pimpriKand"];
  int selectedIdx_2 = -1;

  void onItemClicked(int index) {
    setState(() {
      selectedIdx_2 = index;
    });
  }

  int _currentIndex = 0; // Track the current page index
  String status='';
  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
  int _currentIndexBottom =2; // Track the current page index

  @override
  void initState() {
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });
    Future.delayed(Duration(milliseconds: 8), () {
      getUserCategory();
    });
    super.initState();
  }
  showLoaderDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,

              ),
              width: 80, // Dialog width
              height: 80, // Dialog height
              child: SingleChildScrollView(
                child:Image.asset(
                  "assets/images/loader.gif",
                  width: 80,
                  height: 80,

                ),
              ),
            ),
          ),
        );
      },
    );

  }

  getUserCategory() async{
    showLoaderDialog(context);

    var url = Config.get_user_post_category;
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'user_id':'${deviceId}',

    });

    logger.i("$url\n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('datadata${data}');

    Navigator.of(context).pop();

    if (status == "0") {


      user_category_data = data['data'] as List;
      user_category_string = user_category_data.map<User_Category_list>(
              (json) => User_Category_list.fromJson(json)).toList();


      setState(() {

      });
    }
    else{

    }



  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(

          backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: Colors.white, // Change app bar color to white
          elevation: 0.0, // Remove the bottom border

          iconTheme: IconThemeData(color: Colors.black), // Change icon color to black
          // textTheme: TextTheme(
          //   headline6: TextStyle(color: Colors.black), // Change text color to black
          // ),

          centerTitle: true,
// Back arrow
          title: Row(
            children: [
             // Add spacing between the image and text
              Text('What would you like to do?',
                  style:TextStyle(color: Colors.black,)),
            ],
          ),
          actions: [
            // Add any additional actions here
          ],
        ),


        body:
        WillPopScope(
        onWillPop: () async {
    // Intercept back button press
    // Navigate to HomeScreen and prevent going back to this screen
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) =>CategoryScreen()),
    (route) => false,
    );

    // Return false to prevent the default back button behavior
    return false;
    },
    child:RefreshIndicator(
    onRefresh:_refreshData,
    child:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
            Container(
            width: screenWidth,
            height: screenHeight,
              child:   Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  for(int i=0;i<user_category_string.length;i++)...[

                    GestureDetector(
                      onTap: ()
                      {
                        String url=   "https://wa.me/+91${user_category_string[i].whatsappNumber}?text=${user_category_string[i].whatsappText}";
                        launchUrl(url);

                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Center(
                          child:  Container(
                           child:   showShimmer?
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 12.0,
                                              color: Colors.grey[300],
                                            ),
                                            SizedBox(height: 8.0),
                                            Container(
                                              width: double.infinity,
                                              height: 12.0,
                                              color: Colors.grey[300],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):
                           CachedNetworkImage(
                               width: MediaQuery.of(context).size.width,

                               imageUrl:'${Config.Image_Path+'settings/'+user_category_string[i].categoryImage}',
                               placeholder: (context, url) =>Image.asset(
                                 "assets/images/loader.gif",
                                 width: 80,
                                 height: 80,


                               ),
                               errorWidget: (context, url, error) => Image.asset(
                                 "assets/images/loader.gif",
                                 width: 80,
                                 height: 80,


                               )
                           ),


                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 10),



                ],
              ),


            )
          ),
        ),
        ),
        bottomNavigationBar:  BottomNavigationBar(
          currentIndex: _currentIndexBottom,
          onTap: (int index) {
            setState(() {
              _currentIndexBottom = index;
              if(_currentIndexBottom==0)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   CategoryScreen()));

              }
              if(_currentIndexBottom==1)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityScreen()));

              }

              if(_currentIndexBottom==2)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostScreen()));

              }
              if(_currentIndexBottom==3)
              {

              }

            });
          },
          selectedItemColor: Colors.blue, // Set the selected item color to white
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign),
              label: "Groups",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'More',
            ),
          ],
        ),

      );

  }
  Future _refreshData() async {
    Future.delayed(Duration(milliseconds: 8), () {
      getUserCategory();

    });

  }
  static void launchUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}