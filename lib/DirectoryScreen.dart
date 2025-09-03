import 'dart:convert';
import 'package:localapp/DirectoryDetail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:platform_device_id/platform_device_id.dart';

import 'BuySellScreen.dart';
import 'CategoryScreen.dart';
import 'CityScreen.dart';
import 'HomeScreen.dart';
import 'JobScreen.dart';
import 'NewsScreen.dart';
import 'constants/Config.dart';
import 'models/BlogList.dart';
import 'models/Category.dart';
import 'models/City.dart';
import 'models/DirectoryList.dart';
import 'models/LocalAd.dart';
import 'models/SubCategory.dart';
import 'package:shimmer/shimmer.dart';


class DirectoryScreen extends StatefulWidget {
  String CategoryId;
  DirectoryScreen(this.CategoryId);

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  int selectedIdx = 0;
  int selectedIdx_2 = 0;
  String category_name='';
  String city_name='';
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);

  void onItemClicked(int index,String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category=int.parse(subcat_id);
    });
    getHome();
    //getSubCategory();

  }

  List<String> items = [
    "All",
    "Pandit Ji",
    "Numerology",
    "Tarot Card Reader",
   ];


  final List<String> imageList = [
    'assets/images/directory1.png',
    'assets/images/directory1.png',

  ];
  int blog_page=0;
  String status='';
  int selected_category=0;
  int selected_sub_category=0;

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];

  List directory_data = [];
  List<Directory_list> directory_string = [];
  List<Directory_list> directory_string_list = [];

  List city_data = [];
  List<City_list> city_string = [];

  late ScrollController _scrollController;


  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {

    }
  }


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 8), () {
      //  _showCustomDialog();
      getHome();
    });
    _scrollController = ScrollController()..addListener(_scrollListener);

    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });

    super.initState();
  }



  int _currentIndex = 0; // Track the current page index

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
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

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  BuySellScreen()));

      }
      if(index==3)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewsScreen()));

      }
      if(index==4)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityScreen()));

      }
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = 0;
      } else {
        selectedIdx = index;
      }
    });
  }

  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
  Future _refreshData() async {
    Future.delayed(Duration(milliseconds: 8), () {
      getHome();

    });

  }
  @override
  Widget build(BuildContext context) {
    final originalText = "Your long text goes here. Your long text goes here. Your long text goes here. It can be more than two lines.";
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Create two versions of the text, one truncated and one expanded
    final truncatedText = isExpanded ? originalText : (originalText.length > 50 ? originalText.substring(0, 50) : originalText);

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
            title:

                Row(
                  children: [
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${category_name}',
                            style:TextStyle(color: Colors.black,  fontSize: 18.0,)),

                        Text('${city_name}',
                            style:TextStyle(color: Colors.blue,fontSize: 12.0)),

                      ],
                    )// Add spacing between the image and text
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
              child:
              RefreshIndicator(
                onRefresh:_refreshData,
                child:  SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:


                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(sub_categorylist_string.length, (index) {
                              bool isSelected = index == selectedIdx_2;
                              return GestureDetector(
                                onTap: () => onItemClicked(index,sub_categorylist_string[index].SubCategoryId),
                                child: Container(
                                  height: 40.0,
                                  margin: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.black : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0, // Set the border width
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sub_categorylist_string[index].SubCategoryName,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        // Change text color to white
                                        fontSize: 12.0, // Set font size to a smaller value
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        if(local_ad_string.length>1)...[
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              aspectRatio: 2.0,
                              enableInfiniteScroll: false,
                              viewportFraction:0.8,
                              enlargeCenterPage: false,
                              autoPlay: false,
                              onPageChanged: onPageChanged, // Add the onPageChanged callback
                            ),
                            items: local_ad_string.map((LocalAd_List) {
                              int index = local_ad_string.indexOf(LocalAd_List); // Get the index
                              double containerWidth = MediaQuery.of(context).size.width;
                              if (index == 0) {
                                containerWidth *= 0.7; // First image takes 70% of the screen
                              } else {
                                containerWidth *= 0.3; // Second image takes 30% of the screen
                              }
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: containerWidth,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child:
                                      GestureDetector(
                                          onTap: (){
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
                        if(local_ad_string.length>1)...[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: local_ad_string.map((url) {
                              int index = local_ad_string.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentIndex ? Colors.blue : Colors
                                      .grey, // Change color based on current page index
                                ),
                              );
                            }).toList(),
                          ),

                        ],

                        if(directory_string.length>1)...[
                          for(int j=0;j<directory_string.length;j++)...[
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  DirectoryDetailScreen(directory_string[j].ContactId,directory_string[j].Category,directory_string[j].SubCategory)));

                              },child:         Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                                ),
                                elevation: 4,
                                margin: EdgeInsets.all(16),
                                child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [

                                            showShimmer
                                                ? Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width:60,
                                                height:60,
                                                color: Colors.white,
                                              ),
                                            ):

                                            CachedNetworkImage(
                                              imageUrl:Config.Image_Path+'directory_contact/'+directory_string[j].DisplayPhoto,
                                              height:60,
                                              width:60,
                                              fit: BoxFit.fitHeight,
                                              placeholder: (context, url) => Image.asset(
                                                "assets/images/loader.gif",
                                                width: 50,
                                                height: 50,
                                              ),
                                              errorWidget: (context, url, error) => Image.asset(
                                                "assets/images/loader.gif",
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),



                                            SizedBox(width: 10,),
                                            Container(
                                              child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  showShimmer
                                                      ? Shimmer.fromColors(
                                                    baseColor: Colors.grey[300]!,
                                                    highlightColor: Colors.grey[100]!,
                                                    child: Container(
                                                      width: 150,
                                                      height: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ):
                                                  Container(
                                                      width: 200,
                                                      child:Text(
                                                        '${directory_string[j].FullName}',
                                                        overflow: TextOverflow.ellipsis,

                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                  ),
                                                  SizedBox(height: 5),
                                                  showShimmer
                                                      ? Shimmer.fromColors(
                                                    baseColor: Colors.grey[300]!,
                                                    highlightColor: Colors.grey[100]!,
                                                    child: Container(
                                                      width: 100,
                                                      height: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ):
                                                  Text(
                                                    '${directory_string[j].SubCategoryName}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on, // Map pin icon
                                                        color: Colors.black, // Optional: Set the color of the icon
                                                        size: 15, // Optional: Set the size of the icon
                                                      ),
                                                      SizedBox(width: 2),
                                                      Container(
                                                        width: 250,
                                                        child:  Text(
                                                          '${directory_string[j].ServiceRange}',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      // Add spacing between the icon and text
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [


                                                      Container(
                                                          width: 250, // Set the width as needed
                                                          child:
                                                          Html(
                                                            data:'${directory_string[j].ShortDesc}',
                                                            onLinkTap: (url, _, __, ___) async {
                                                              if (await canLaunch(url!)) {
                                                                await launch(
                                                                  url,
                                                                );
                                                              }
                                                            },

                                                          )
                                                      ),

                                                    ],
                                                  ),

                                                  if(directory_string[j].IDVerified=='Y')...[
                                                    Spacer(),
                                                    Image.asset(
                                                      'assets/images/IDVerifiedLabel.png',
                                                      height: 40,
                                                      width: 60,
                                                    ),

                                                  ]

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: (){

                                                launchUrl("tel://${directory_string[j].CallingNumber}");
                                              },child:

                                            Row(
                                              children: [


                                                Image.asset(
                                                  'assets/images/call.png',
                                                  height: 25,
                                                  width: 25,
                                                ),  SizedBox(width: 2),
                                                Text('Call'),
                                              ],
                                            ),
                                            ),
                                            GestureDetector(
                                              onTap: (){

                                                launchUrl("https://wa.me/+91${directory_string[j].WhatsappNumber}");
                                              },child:

                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/whatsapp.png',
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                SizedBox(width: 2),
                                                Text('WhatsApp'),
                                              ],
                                            ),
                                            ),

                                            GestureDetector(
                                              onTap: (){

                                                launchUrl("tel://${directory_string[j].AlternateNumber}");
                                              },child:

                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/share.png',
                                                  height: 25,
                                                  width: 25,
                                                ), SizedBox(width: 2),
                                                Text('Share'),
                                              ],
                                            ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )

                                ),
                              ),
                            )


                            )


                          ],
                        ],



                      ],
                    ),
                  ),










              ),
      ));
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


  getHome() async{
    showLoaderDialog(context);
    selected_category=int.parse(widget.CategoryId);
    var url = Config.get_contact_home;

    print('selected_category${selected_category}');
    print('selected_sub_category${selected_sub_category}');
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${selected_category}',
      'subcategory_id':'$selected_sub_category',
      'user_id':'${deviceId}',
      'page':'${blog_page}'
    });

    logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');


    if (status == "0") {
      Navigator.of(context).pop();

      category_name=data['data']['category_name'];
      city_name=data['data']['city_name']==null?'':data['data']['city_name'];
      sub_categorylist_data = data['data']['sub_category'] as List;
      sub_categorylist_string = sub_categorylist_data.map<SubCategory_list>(
              (json) => SubCategory_list.fromJson(json)).toList();

      local_ad_data = data['data']['local_ad'] as List;
      local_ad_string = local_ad_data.map<LocalAd_list>(
              (json) => LocalAd_list.fromJson(json)).toList();

      directory_data = data['data']['blog'] as List;
      directory_string = directory_data.map<Directory_list>((json) => Directory_list.fromJson(json)).toList();
      print('directory_string${directory_data}');

      setState(() {
        // directory_string.addAll(directory_string_list);
      });
    }
    else{
      Navigator.of(context).pop();

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

}