import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:localapp/CityDetailScreen.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/MyPostScreen.dart';
import 'package:localapp/models/AreaList.dart';
import 'package:localapp/models/Category.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'MoreScreen.dart';
import 'PostScreen.dart';
import 'constants/Config.dart';
import 'constants/prefs_file.dart';
import 'package:platform_device_id/platform_device_id.dart';


class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  TextEditingController searchController = TextEditingController();

  Prefs prefs = new Prefs();
  bool isSeached=false;
  String recent_id='';
  String recent_image='';
  int area_string_length=1;
  Timer searchOnStoppedTyping = Timer(Duration(milliseconds: 1), () {});
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);

  int selectedIdx = -1;
  String status='';
  List<String> items = [
    "News",
    "Jobs",
    "Buy Sell Rent",
    "Pune Clubs",
    "Offers"
  ];
  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List area_data = [];
  List<Area_list> area_string = [];
  int _currentIndexBottom = 1; // Track the current page index

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 8), () {
      getArea();
    });
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });

    super.initState();
  }

  void selectItem(int index,String cat_id) {
    setState(() {
      getArea();
     
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = 0;
      } else {
        selectedIdx = index;
      }
    });
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

  getArea() async{
     recent_id = await prefs.getrecent_id();
     recent_image = await prefs.getrecent_image();
     print('recent_id${recent_id}');

     showLoaderDialog(context);

    var url = Config.get_city_area;
     String? deviceId = await PlatformDeviceId.getDeviceId;

     http.Response response = await http.post(Uri.parse(url), body: {
      'city_id':'1',
       'user_id':'${deviceId}',

     });

     logger.i("$url \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('data${data}');


    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();

      
      area_data = data['data']['area'] as List;
      area_string = area_data.map<Area_list>(
              (json) => Area_list.fromJson(json)).toList();

      setState(() {
        area_string_length=area_string.length;

      });
      print('area_string_length${area_string_length}');
    }
    else{
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
    }



  }
  search_selected(String keyword) async{
    showLoaderDialog(context);
    var url = Config.get_search_city_area;
    String? deviceId = await PlatformDeviceId.getDeviceId;


    http.Response response = await http.post(Uri.parse(url), body: {
      'city_id':'1',
      'keyword':'${keyword}',
      'user_id':'${deviceId}',

    });

    logger.i("$url \n${response.statusCode} \n ${json.decode(response.body)}");
    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');

    Navigator.of(context).pop();
    if (status == "0") {

      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();


      area_data = data['data']['area'] as List;
      area_string = area_data.map<Area_list>(
              (json) => Area_list.fromJson(json)).toList();

      setState(() {
        area_string_length=area_string.length;

      });
      print('area_string_length${area_string_length}');

    }
    else{

    }


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

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
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
                Text('Select Area',
                    style:TextStyle(color: Colors.black,)),
              ],
            ),
            actions: [
              // Add any additional actions here
            ],
          ),
        body: WillPopScope(
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
          child:
          RefreshIndicator(
            onRefresh:_refreshData,
            child:
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Grey border
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                      child: TextField(
                        controller: searchController,
                          onChanged: (text) {
                          const duration = Duration(
                              milliseconds: 200); // set the duration that you want call search() after that.
                          if (searchOnStoppedTyping != null) {
                            setState(() => searchOnStoppedTyping.cancel()); // clear timer
                          }
                          if(text.length==0)
                            {
                              setState(() => searchOnStoppedTyping = new Timer(duration, () => search_selected(text)));

                            }

                        },
                        onSubmitted:(text) {
                          const duration = Duration(
                              milliseconds: 200); // set the duration that you want call search() after that.
                          if (searchOnStoppedTyping != null) {
                            setState(() =>
                                searchOnStoppedTyping.cancel()); // clear timer
                          }
                          setState(() =>
                          searchOnStoppedTyping =
                          new Timer(duration, () => search_selected(text)));

                        },
                        decoration: InputDecoration(
                          hintText: 'Search by area', // Placeholder text
                          hintStyle: TextStyle(color: Colors.grey,  fontSize: 14.0, ), // Change hint text color to grey
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0), // Adjust text padding
                          border: InputBorder.none, // Remove the default TextField border
                          suffixIcon:
                          GestureDetector(
                            onTap: (){
                              print('search clicked');
                              search_selected(searchController.text);
                              setState(() {

                                isSeached=true;
                              });

                            },
                            child:   Icon(Icons.search,
                              color: Colors.black87,),
                          ), // Search icon in the suffix
                        ),
                      ),
                    ),
                  ),

                  if(area_string_length==0)...[

                    Image.asset(
                      "assets/images/no_data.gif",

                    ),
                  ]
                  else...[
                    if(recent_id!='0' && isSeached==false)...[

                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Recent',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      showShimmer?
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
                                width: 80.0,
                                height: 80.0,
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
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityDetailScreen(recent_id)));
                        },
                        child:    Center(
                          child:  Row(
                            children: [

                              CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width-20,
                                  imageUrl:"${Config.Image_Path+'area/${recent_image}'}",
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

                            ],
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 20),

                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'All',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    for(int i=0;i<area_string.length;i++)...[

                      SizedBox(height: 10),
                      showShimmer?
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
                                width: 80.0,
                                height: 80.0,
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
                      GestureDetector(
                        onTap: ()
                        {

                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityDetailScreen(area_string[i].AreaId)));
                          prefs.setrecent_id(area_string[i].AreaId);
                          prefs.setrecent_image(area_string[i].DisplayPhoto);
                        },
                        child:    Center(
                          child:  Row(
                            children: [

                              CachedNetworkImage(
                                width: MediaQuery.of(context).size.width-20,
                                imageUrl:"${Config.Image_Path+'area/'+area_string[i].DisplayPhoto}",
                                placeholder: (context, url) =>Image.asset(
                                  "assets/images/loader.gif",
                                  width: 80,
                                  height: 80,


                                ),

                              ),


                            ],
                          ),
                        ),
                      ),

                    ],


                  ]





                ],
              ),


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
              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));

            }
            if(_currentIndexBottom==1)
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityScreen()));

            }

            if(_currentIndexBottom==2)
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyPostScreen(false)));

            }
            if(_currentIndexBottom==3)
            {
              // showCustomPopup(context,'','','','');
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MoreScreen()));

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
            icon: Icon(Icons.post_add_outlined),
            label: 'My Posts',
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
      getArea();
    });

  }
}