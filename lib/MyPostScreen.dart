import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/CategoryScreen.dart';
import 'package:localapp/models/BlogList.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:connectivity/connectivity.dart';

import 'AddPostScreen.dart';
import 'MoreScreen.dart';
import 'MyBlogListWidget.dart';
import 'CityScreen.dart';
import 'InternetLostScreen.dart';
import 'constants/Config.dart';
import 'constants/prefs_file.dart';
import 'models/City.dart';
import 'models/LocalAd.dart';
class MyPostScreen extends StatefulWidget {

  bool isVisible;
  MyPostScreen(this.isVisible);

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {


  int selectedIdx = 0;
  int blog_page=0;
  int total_page=0;
  bool load_more=true;
  String status='';
  String notification_popup='';
  int selected_category=0;
  int selected_sub_category=0;
  String Uploading='0';

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];


  List notification_ad_data = [];
  List<LocalAd_list> notification_ad_string = [];

  List blog_data = [];
  List<Blog_list> blog_string = [];
  List<Blog_list> blog_string_list = [];
  int category_string_length=1;

  int blog_string_count=0;
  List city_data = [];
  List<City_list> city_string = [];



  final navigatorKey = GlobalKey<NavigatorState>();
  late ScrollController _scrollController;
  Prefs prefs = new Prefs();

  bool isVisibleDiv=false;
  @override
  void initState() {
    if(widget.isVisible==true){
      setState(() {
        isVisibleDiv=true;
      });
      check_uploading();
      }

    Future.delayed(Duration(milliseconds: 1), () {
      _initConnectivity();
      getApi(context);
    });
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  check_uploading() async {
    String post_uploading = await prefs.getpost_uploading();

    if(post_uploading=='Yes')
      {
        setState(() {
          isVisibleDiv=true;
        });
      }
    else{
      setState(() {
        isVisibleDiv=false;
      });
    }
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InternetLostScreen(),
        ),
      );
    }
  }


  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('total_page${total_page}');
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


  Future<void> checkInternetConnectivity() async {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InternetLostScreen(),
        ),
      );
    }
    // Listen for changes in connectivity status
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InternetLostScreen(),
          ),
        );
      }
    });
  }

  Future<void> getApi(BuildContext context) async {
    showLoaderDialog(context);



    blog_data = [];
    blog_string = [];
    local_ad_data = [];
    local_ad_string = [];
    sub_categorylist_data = [];
    sub_categorylist_string = [];

    var url = Config.get_my_post;
    blog_page=0;
    String? deviceId = await PlatformDeviceId.getDeviceId;


    http.Response response = await http.post(Uri.parse(url), body: {
      'blog_page':'${blog_page}',
      'PostById':'$deviceId',
      'user_id':'$deviceId'

    }) .timeout(Duration(seconds: 20));


    // Set timeout to 30 seconds
    Map<String, dynamic> data = json.decode(response.body );

    status = data["success"];

    Logger().i("${url}\n  {'blog_page':'${blog_page}','PostById':'$deviceId','user_id':'$deviceId'} ");


    Logger().e("Get My Post Api ${response.statusCode}\n${response.body}");
    Logger().e("${DateTime.now().toIso8601String()}");

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();

      });

      if (status == "0") {

        setState(() {
          blog_data = data['data']['blog'] as List;

          blog_string= blog_data.map<Blog_list>((json) => Blog_list.fromJson(json)).toList();
          total_page=data['data']['total_page']==null?0:data['data']['total_page'];
          Uploading=data['uploading'] as String;
          category_string_length=blog_string.length;
          if(Uploading=='1')
          {

            isVisibleDiv=true;
          }
          else{
            isVisibleDiv=false;
            Logger().e("7");
          }
        });
        print('total_page${total_page}');


      }
      else{
        category_string_length=0;
      }



    }
    else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();

      });
    }

    // try {
    //
    //
    // } catch (e) {
    //   print('Request failed with error: $e');
    //   // Show retry popup
    //   Navigator.of(context).pop();
    //
    //   RetryPopup();
    // }
  }

  RetryPopup()
  {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch data. Retry?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                getApi(context); // Retry fetching data
                //Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  getMoreHome() async{
    print('get_home_called${blog_page}');

    showLoaderDialog(context);

    var url = Config.get_my_post;
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'blog_page':'${blog_page}',
      'PostById':'$deviceId',
      'user_id':'$deviceId'

    });

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    logger.i("$url\n ${response.statusCode} \n${data}");



    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
      blog_data = data['data']['blog'] as List;
      List<Blog_list> blog_string_data= blog_data.map<Blog_list>(
              (json) => Blog_list.fromJson(json)).toList();


      setState(() {

        blog_string.addAll(blog_string_data);
        total_page=data['data']['total_page']==null?0:data['data']['total_page'];
        if(total_page==blog_page)
        {
          load_more=false;
        }
      });
      Uploading=data['uploading'] as String;
      print('moreuploading${data['uploading']}');
      if(Uploading=='1')
      {
        isVisibleDiv=true;
      }
      else{
        isVisibleDiv=false;

      }
    }
    else{
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
    }



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



  int _currentIndex = 0; // Track the current page index
  int _currentIndexBottom = 2; // Track the current page index

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  CategoryScreen()));
          },
        ),
        iconTheme: IconThemeData(color: Colors.black), // Change icon color to black
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.black), // Change text color to black
        // ),

        centerTitle: true,
// Back arrow
        title: Row(
          children: [
            // Add spacing between the image and text
            Text('My Posts',
                style:TextStyle(color: Colors.black,)),
          ],
        ),
        actions: [

        ],
      ),

      body:  WillPopScope(
          onWillPop: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  CategoryScreen()));
            return false;
          },
          child:
              RefreshIndicator(
                  onRefresh:_refreshData,
                  child:


                  ListView(
                    controller: _scrollController,
                    children: [
                      if(category_string_length==0)...[

                Image.asset(
                "assets/images/no_data.gif",

              ),
          ]
          else...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Visibility(
                              visible: isVisibleDiv,
                              child:   Card(
                                margin: EdgeInsets.all(15.0), // Margin of 10 pixels around the container
                                child:
                                Image.asset(
                                  'assets/images/PostUploadInProgress.gif',
                                  width:double.infinity,
                                  fit: BoxFit.cover,
                                  height: 80,// Image asset path
                                ),


                              )),

                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: blog_string.length + 1, // +1 for the loading indicator
                            itemBuilder: (context, index) {
                              if (index == blog_string.length) {
                                if (load_more == true) return _buildLoadingIndicator();
                              } else {
                                return MyBlogListWidget(blog_string[index], '${selected_category}', '${selected_sub_category}');
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
                      ),
    ]
                    ],
                  )










              )







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
      getApi(context);

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
