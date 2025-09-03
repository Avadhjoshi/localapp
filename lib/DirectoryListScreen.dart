import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/CategoryScreen.dart';
import 'package:localapp/HomeScreen.dart';
import 'package:localapp/models/BlogList.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';


import 'BlogDetail.dart';
import 'DirectoryListWidget.dart';
import 'CityScreen.dart';
import 'PostScreen.dart';
import 'constants/Config.dart';
import 'models/City.dart';
import 'models/LocalAd.dart';
import 'package:flutter_html/flutter_html.dart';

import 'models/directoryList.dart';

class DirectoryScreen extends StatefulWidget {
  String CategoryId,AreaId;
  DirectoryScreen(this.CategoryId,this.AreaId);

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {

  String category_name='';
  String city_name='';
  String area_name='';

  int selectedIdx = 1;
  int blog_page=0;
  int total_page=0;
  bool load_more=true;
  String status='';
  String notification_popup='';
  int selected_category=0;
  int selected_sub_category=0;

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];


  List notification_ad_data = [];
  List<LocalAd_list> notification_ad_string = [];

  List blog_data = [];
  List<Directory_list> blog_string = [];
  List<Directory_list> blog_string_list = [];

  List city_data = [];
  List<City_list> city_string = [];

  int blog_string_length=1;


  final navigatorKey = GlobalKey<NavigatorState>();
  late ScrollController _scrollController;


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () {
      //  _showCustomDialog();
      getHome();
    });
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }
  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('total_page${total_page}');
      print('blog_page${blog_page}');
      // User has reached the end of the list, load more data
      if(blog_page!=total_page)
      {
        print('calledscrollListener');
        setState(() {
          blog_page++;

        });

        getMoreHome();
      }
    }
  }


  getHome() async{

    showLoaderDialog(context);
    blog_data = [];
    blog_string = [];
    local_ad_data = [];
    local_ad_string = [];
    sub_categorylist_data = [];
    sub_categorylist_string = [];
    selected_category=int.parse(widget.CategoryId);
    String? deviceId = await PlatformDeviceId.getDeviceId;

    var url = Config.get_contact_home;
   // blog_page=1;
    print('category_id${selected_category}');
    print('subcategory_id${selected_sub_category}');
    print('area_id${widget.AreaId}');

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${selected_category}',
      'subcategory_id':'$selected_sub_category',
      'blog_page':'${blog_page}',
      'user_id':'${deviceId}',
      'city_id':'1',
      'area_id':'${widget.AreaId}'
    });

    logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];


    if (status == "0") {

      category_name=data['data']['category_name']==null?'':data['data']['category_name'];
      city_name=data['data']['city_name']==null?'':data['data']['city_name'];
      area_name=data['data']['area_name']==null?'':data['data']['area_name'];


      local_ad_data = data['data']['local_ad'] as List;
      local_ad_string = local_ad_data.map<LocalAd_list>(
              (json) => LocalAd_list.fromJson(json)).toList();
      sub_categorylist_data = data['data']['sub_category'] as List;
      sub_categorylist_string = sub_categorylist_data.map<SubCategory_list>(
              (json) => SubCategory_list.fromJson(json)).toList();

      blog_data = data['data']['blog'] as List;
      blog_string= blog_data.map<Directory_list>(
              (json) => Directory_list.fromJson(json)).toList();
      total_page=data['data']['total_page']==null?0:data['data']['total_page'];
      print('total_pageee${total_page}');
      blog_string_length=blog_string.length;


    }
    else{
      blog_string_length=0;

    }

    getCity();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();

    });
    //showCustomPopup(context,notification_ad_string[0].AdImage,notification_ad_string[0].WhatsappNumber,notification_ad_string[0].WhatsappText,notification_ad_string[0].Url);



  }
  getMoreHome() async{
    print('get_home_called${blog_page}');

    showLoaderDialog(context);

    var url = Config.get_home;

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${selected_category}',
      'subcategory_id':'$selected_sub_category',
      'blog_page':'${blog_page}',
      'city_id':'1'
    });

    logger.i("$url\n${response.statusCode}\n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];


    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();
      if(selected_category==0)
      {
        selected_category=int.parse(categorylist_string[0].CategoryId);
      }
      sub_categorylist_data = data['data']['sub_category'] as List;
      sub_categorylist_string = sub_categorylist_data.map<SubCategory_list>(
              (json) => SubCategory_list.fromJson(json)).toList();

      local_ad_data = data['data']['local_ad'] as List;
      local_ad_string = local_ad_data.map<LocalAd_list>(
              (json) => LocalAd_list.fromJson(json)).toList();

      blog_data = data['data']['blog'] as List;
      List<Directory_list> blog_string_data= blog_data.map<Directory_list>(
              (json) => Directory_list.fromJson(json)).toList();


      setState(() {

        blog_string.addAll(blog_string_data);
        total_page=data['data']['total_page']==null?0:data['data']['total_page'];
          print('total_pagee${total_page}');
        if(total_page==blog_page)
        {
          load_more=false;
        }
      });
    }
    else{
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
    }

    getCity();


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

  getSubCategory() async{

    var url = Config.get_sub_category;
    print('selected_category${selected_category}');

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${selected_category}',
    });

    logger.i("$url ${response.statusCode}\n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];



    if (status == "0") {

      sub_categorylist_data = data['data'] as List;
      sub_categorylist_string = sub_categorylist_data.map<SubCategory_list>(
              (json) => SubCategory_list.fromJson(json)).toList();

    }
    else{

    }



  }

  getCity() async{

    var url = Config.get_city;

    http.Response response = await http.post(Uri.parse(url), body: {
    });
    logger.i("$url \n${response.statusCode} \n${jsonDecode(response.body)}");
    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');




    if (status == "0") {


      setState(() {
        city_data = data['data'] as List;
        city_string = city_data.map<City_list>(
                (json) => City_list.fromJson(json)).toList();
        print('city_string${data}');
      });
    }
    else{

    }



  }

  void selectItem(int index,String cat_id) {
    if(selectedIdx!=index) {
      setState(() {
        selected_category = int.parse(cat_id);
        selectedIdx_2=0;
        selected_sub_category = 0;
        getHome();
        //getSubCategory();

        if (index == selectedIdx) {
          // If the same item is tapped again, clear the selection
          selectedIdx = 0;
        } else {
          selectedIdx = index;
        }
      });
    }
  }
  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to exit?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('no selected');
                              Navigator.of(context).pop();
                            },
                            child:
                            Text("No", style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
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
  int selectedIdx_2 = 0;


  void onItemClicked(int index,String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category=int.parse(subcat_id);
    });
    getHome();
    //getSubCategory();

  }
  int _currentIndex = 0; // Track the current page index
  int _currentIndexBottom = 1; // Track the current page index

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

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
          title:

          Row(
            children: [
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 230,
                    child:   Text('${category_name}',
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(color: Colors.black,  fontSize: 18.0,)),
                  ),// Add spacing between the image and text


                  Text('${area_name}',
                      style:TextStyle(color: Colors.blue,fontSize: 12.0)),

                ],
              )// Add spacing between the image and text
            ],
          ),

          actions: [
            // Add any additional actions here
          ],
          bottom:  PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(sub_categorylist_string.length, (index) {
                  bool isSelected = index == selectedIdx_2;
                  return GestureDetector(
                    onTap: () => onItemClicked(index, sub_categorylist_string[index].SubCategoryId),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(5.0),
                      decoration: isSelected
                          ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blue, // Color of the underline
                            width: 2.0, // Fixed underline thickness when isSelected is true
                          ),
                        ),
                      )
                          : null,
                      child: Text(
                        sub_categorylist_string[index].SubCategoryName,
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )

        ),

        body:  WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child:
            RefreshIndicator(
              onRefresh:_refreshData,
              child:


              ListView(
                controller: _scrollController,
                children: [



            Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(local_ad_string.length==1)...[
                        GestureDetector(
                            onTap: (){

                              ad_response(local_ad_string[0].AdId);
                              String w_no=local_ad_string[0].WhatsappNumber;
                              String w_msg=local_ad_string[0].WhatsappText;
                              String url="https://wa.me/+91${w_no}?text=${w_msg}";
                              if(local_ad_string[0].Url!='')
                              {
                                url=local_ad_string[0].Url;
                              }

                              launchUrl(url);
                            },
                            child:
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child:
                              CachedNetworkImage(
                                imageUrl:Config.Image_Path+'local_ad/'+local_ad_string[0].AdImage,
                                placeholder: (context, url) =>Image.asset(
                                  "assets/images/loader.gif",
                                  width: 80,
                                  height: 80,

                                ),
                                errorWidget: (context, url, error) =>Image.asset(
                                  "assets/images/loader.gif",
                                  width: 80,
                                  height: 80,

                                ),
                              ),

                            )
                        )
                      ],
                      if(local_ad_string.length>1)...[
                        CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height/2,

                            aspectRatio: 2.0,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: false,
                            initialPage: 0,
                            onPageChanged: onPageChanged, // Add the onPageChanged callback
                          ),
                          items: local_ad_string.map((LocalAd_List) {
                            int index = local_ad_string.indexOf(LocalAd_List); // Get the index

                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,

                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      //    border: Border.all(color: Colors.blueAccent)

                                    ),
                                    child:
                                    GestureDetector(
                                        onTap: (){
                                          ad_response(local_ad_string[index].AdId);

                                          String w_no=local_ad_string[index].WhatsappNumber;
                                          String w_msg=local_ad_string[index].WhatsappText;
                                          String url="https://wa.me/+91${w_no}?text=${w_msg}";
                                          if(local_ad_string[index].Url!='')
                                          {
                                            url=local_ad_string[index].Url;
                                          }

                                          launchUrl(url);
                                        },
                                        child:

                                        CachedNetworkImage(
                                          imageUrl:Config.Image_Path+'local_ad/'+local_ad_string[index].AdImage,
                                          placeholder: (context, url) => Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,
                                          ),
                                        )
                                    )
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],

                      if(blog_string_length==0)...[

              Image.asset(
              "assets/images/no_data.gif",

            ),
            ]
            else...[

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: blog_string.length + 1, // +1 for the loading indicator
                        itemBuilder: (context, index) {
                          print('index${index}');
                          print('blog_string.length${blog_string.length}');
                          if (index == blog_string.length) {
                            if (load_more == true) return _buildLoadingIndicator();
                          } else {
                            return DirectoryListWidget(blog_string[index], '${blog_string[index].CategoryName}', '${blog_string[index].SubCategoryName}',false);
                          }
                        },
                      ),
                      if(blog_string.length>0)...[


                                  Container(
                                    width: double.infinity,
                                    child: Image.asset(
                                      'assets/images/BottomImage.png',
                                      fit: BoxFit.fill, // Adjust this according to your needs
                                    ),
                                  )
                                ]
                    ],


                    ],
                  ),

                ],
              ),









            )





        ),


      );
  }

  String selectedCity = 'Option 1';
  String selectedArea = 'Option 1';
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(),
      ),
    );
  }
  Future _refreshData() async {
    Future.delayed(Duration(milliseconds: 1), () {
      getHome();

    });

  }
  ad_response(ad_id) async {

    var url = Config.insert_ad_response;
    String? deviceId = await PlatformDeviceId.getDeviceId;
      print('deviceId${deviceId}');
      print('ad_id${ad_id}');
    http.Response response = await http.post(Uri.parse(url)
         , body: {
          "user_id": '${deviceId}',
          "ad_id":'${ad_id}'
        });

    logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");




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

  Widget buildCustomDropdown(String label, String selectedValue) {
    return Container(
      padding: EdgeInsets.all(2.0),
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add grey border
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
                child:DropdownButton<String>(
                  iconSize: 0.0,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: city_string.map<DropdownMenuItem<String>>(
                        (City_list city) {
                      return DropdownMenuItem<String>(
                        value: city.CityId, // Replace with the actual property
                        child: Text(city.CityName), // Replace with the actual property
                      );
                    },
                  ).toList(),
                  hint: Text(label),
                )
            ),
          ),
        ],
      ),
    );
  }

}
void showCustomPopup(BuildContext context,image,WhatsappNumber,WhatsappText,Url) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomPopup(
          onClose: () {
            // Call your function here
            print('Function called on close button click');
          },
          image: image,
          WhatsappNumber:WhatsappNumber,
          WhatsappText:WhatsappText,
          Url:Url
      );
    },
  );
}




class CustomPopup extends StatelessWidget {
  final Function onClose;
  final String image;
  final String WhatsappNumber;
  final String WhatsappText;
  final String Url;
  const CustomPopup({Key? key, required this.onClose,required this.image,required this.WhatsappNumber,required this.WhatsappText,required this.Url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              String w_no=WhatsappNumber;
              String w_msg=WhatsappText;
              String w_url="https://wa.me/+91${w_no}?text=${w_msg}";
              if(Url!='')
              {
                w_url=Url;
              }

              launchUrl(Uri.parse(w_url));

            },
            child: Container(
              width: MediaQuery.of(context).size.width-50,
              height:MediaQuery.of(context).size.height-150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Set the border radius
              ),
              child:   CachedNetworkImage(
                imageUrl:Config.Image_Path+'local_ad/${image}',
                placeholder: (context, url) =>Image.asset(
                  "assets/images/loader.gif",
                  width: 80,
                  height: 80,

                ),
                errorWidget: (context, url, error) =>Image.asset(
                  "assets/images/loader.gif",
                  width: 80,
                  height: 80,

                ),
              ),





            ),
          ),

          Positioned(
            top: 1.0,
            right: 1.0,
            child: GestureDetector(
              onTap: () {
                onClose();
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  size: 24.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
