import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:localapp/CityScreen.dart';
import 'package:localapp/DirectoryListScreen.dart';
import 'package:http/http.dart' as http;
import 'constants/Config.dart';
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';

import 'models/Category.dart';
import 'models/LocalAd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CityDetailScreen extends StatefulWidget {
  String AreaId;
  CityDetailScreen(this.AreaId);

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);
  Timer searchOnStoppedTyping = Timer(Duration(milliseconds: 1), () {});
  TextEditingController searchController = TextEditingController();
  int category_string_length=1;

  final List<String> imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];



  int _currentIndex = 0; // Track the current page index
  int page=0;
  String status='';

  String area_name='';
  String area_image='';

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
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
      //  _showCustomDialog();
      getHome();
    });
    super.initState();
  }
  getHome() async{
    showLoaderDialog(context);

    var url = Config.get_area_home;
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'area_id':'${widget.AreaId}',
      'user_id':'${deviceId}',
      'page':'${page}'
    });

    logger.i("$url \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');
    Navigator.of(context).pop();


    if (status == "0") {

      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();

      local_ad_data = data['data']['local_ad'] as List;
      local_ad_string = local_ad_data.map<LocalAd_list>(
              (json) => LocalAd_list.fromJson(json)).toList();


      setState(() {
        area_name=data['data']['area_data'][0]['AreaName']==null?'':data['data']['area_data'][0]['AreaName'];
        area_image=data['data']['area_data'][0]['AreaImage']==null?'':data['data']['area_data'][0]['AreaImage'];
        // blog_string.addAll(blog_string_list);
        category_string_length=categorylist_string.length;
      });
    }
    else{

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
          title: Row(
            children: [

              if(area_image!='')...[
                CachedNetworkImage(
                  imageUrl:Config.Image_Path+'area/'+area_image,
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
                )
              ],
              SizedBox(width: 8),
              Container(
                width: 300,
                child:   Text('${area_name}',
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(color: Colors.black,)),
              )// Add spacing between the image and text

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
                  MaterialPageRoute(builder: (context) => CityScreen()),
                      (route) => false,
                );

                // Return false to prevent the default back button behavior
                return false;
              },
              child:
              RefreshIndicator(
                onRefresh:_refreshData,
                child:SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                                    hintText: 'Search services you are looking for', // Placeholder text
                                    hintStyle: TextStyle(color: Colors.grey,            fontSize: 14.0, ), // Change hint text color to grey
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0), // Adjust text padding
                                    border: InputBorder.none, // Remove the default TextField border
                                    suffixIcon:

                                    GestureDetector(
                                      onTap: (){
                                        print('search clicked');
                                        search_selected(searchController.text);

                                      },
                                      child:
                                      Icon(Icons.search,
                                        color: Colors.black87,), // Search icon in the suffix
                                    ),
                                  ),
                                  /*onChanged: (text) {
                                const duration = Duration(
                                    milliseconds: 200); // set the duration that you want call search() after that.
                                if (searchOnStoppedTyping != null) {
                                  setState(() =>
                                      searchOnStoppedTyping.cancel()); // clear timer
                                }
                                setState(() =>
                                searchOnStoppedTyping =
                                new Timer(duration, () => search_selected(text)));

                              },*/

                                ),
                              ),
                            ),

                            if(category_string_length==0)...[

                              Image.asset(
                                "assets/images/no_data.gif",

                              ),
                            ]else...[


                            if(local_ad_string.length==1)...[
                              GestureDetector(
                                  onTap: (){
                                    ad_response(local_ad_string[0].AdId);
                                    String w_no=local_ad_string[0].WhatsappNumber;
                                    String w_msg=local_ad_string[0].WhatsappText;
                                    String url="https://wa.me/+91${w_no}?text=${w_msg}";
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
                                  height: 200.0,
                                  enlargeCenterPage: false,
                                  autoPlay: false,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
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
                                          ),
                                          child:
                                          GestureDetector(
                                              onTap: (){
                                                ad_response(local_ad_string[index].AdId);
                                                String w_no=local_ad_string[index].WhatsappNumber;
                                                String w_msg=local_ad_string[index].WhatsappText;
                                                String url="https://wa.me/+91${w_no}?text=${w_msg}";
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

                            SizedBox(height: 20.0),
                            for(int i=0;i<categorylist_string.length;i++)...[
                              if(categorylist_string[i].DisplaySequence=='1')...[
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
                                Center(
                                    child:  GestureDetector(
                                        onTap: ()
                                        {

                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DirectoryScreen(categorylist_string[i].CategoryId,widget.AreaId)));

                                        },
                                        child:
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(8.0),
                                          child:        CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width-20,
                                              imageUrl:"${Config.Image_Path+'directory_contact/'+ categorylist_string[0].CategoryPhoto}",
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



                                        )
                                    )
                                )
                              ]
                            ],
                            Wrap(
                                spacing: 5.0, // Adjust the spacing between items
                                runSpacing: 5.0, // Adjust the spacing between lines
                                children: List.generate(
                                  categorylist_string.length,
                                      (index) {
                                    return  categorylist_string[index].DisplaySequence!='1'?
                                    Container(
                                      width: (screenWidth - 5.0 * 3) / 2, // Adjust the width based on spacing
                                      child:
                                      Container(
                                        margin: EdgeInsets.all(5.0),
                                        child:
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

                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  DirectoryScreen(categorylist_string[index].CategoryId,widget.AreaId)));

                                          },
                                          child:           CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width-20,
                                              imageUrl:"${Config.Image_Path+'directory_contact/'+categorylist_string[index].CategoryPhoto}",
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
                                    ):Container();
                                  },
                                ),
                              ),
                            SizedBox(height: 10)
                            ],
                            if(categorylist_string.length>0)...[


                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/BottomImage.png',
                                  fit: BoxFit.fill, // Adjust this according to your needs
                                ),
                              )
                            ]


                          ],
                        )





                ),

              )


          )



      );
  }
  Future _refreshData() async {
    Future.delayed(Duration(milliseconds: 8), () {
      getHome();

    });

  }

  search_selected(String keyword) async{
    showLoaderDialog(context);

    var url = Config.get_search_area_home;
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'area_id':'${widget.AreaId}',
      'keyword':'${keyword}',
      'user_id':'${deviceId}',
      'page':'${page}'
    }).timeout(Duration(seconds: 20));
    Map<String, dynamic> data = json.decode(response.body );
    print('datadata${data}');
    status = data["success"];
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();

    });

    setState(() {


    if (status == "0") {

      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();
      category_string_length=categorylist_string.length;
      print('categorylist_string${data['data']['category']}');

    }
    else{

    }
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