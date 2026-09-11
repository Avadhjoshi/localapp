import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'constants/Config.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/models/BlogList.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:photo_view/photo_view.dart';

import 'image_viewer.dart';
import 'models/BlogDetailList.dart';
import 'models/LocalAd.dart';
import 'package:shimmer/shimmer.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:platform_device_id/platform_device_id.dart';


class VideoPlayer extends StatefulWidget {
  String BlogPostId;
  VideoPlayer(this.BlogPostId);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);

  int selectedIdx = 0;
  String status='';
  int selected_category=1;
  int selected_sub_category=1;

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];

  List blog_data = [];
  List<Blog_Detail_list> blog_string=[];
  String CategoryName='';
  int _currentIndex=0;

  String BlogPostId='';
  String Heading='';
  String HText='';
  String PostDisplayPhoto='';
  String TimeAgo='';
  String SubCategoryName='';
  String PostImage1='';
  String PostImage2='';
  String PostImage3='';
  String PostImage4='';
  String PostImage5='';
  String PostCategory='';
  String PostSubCategory='';
  String VideoLink='';
  String ShareText='';
  String ShareLink='';
  String videoId='';

  late YoutubePlayerController _controller=YoutubePlayerController(
    initialVideoId: '${videoId}',
    flags: YoutubePlayerFlags(
      autoPlay: false,
    ),
  );


  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () {
      GetBlogData();
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



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void selectItem(int index,String cat_id) {
    setState(() {
      selected_category=int.parse(cat_id);
      GetBlogData();
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = 0;
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

  void onItemClicked(int index,String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category=int.parse(subcat_id);
    });
    // getBlogData();

  }


  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
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

  GetBlogData() async{
    //showLoaderDialog(context);
    var url = Config.get_blog_data;
    print('post_id${widget.BlogPostId}');
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'post_id':'${widget.BlogPostId}',
      'user_id':'${deviceId}'
    });

    logger.i("$url ${response.statusCode}\n ${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');


    if (status == "0") {
      // Navigator.of(context).pop();

      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();

      sub_categorylist_data = data['data']['sub_category'] as List;
      sub_categorylist_string = sub_categorylist_data.map<SubCategory_list>(
              (json) => SubCategory_list.fromJson(json)).toList();

      local_ad_data = data['data']['local_ad']==null?[]: data['data']['local_ad'] as List;
      local_ad_string = local_ad_data.map<LocalAd_list>(
              (json) => LocalAd_list.fromJson(json)).toList();

      blog_data = data['data']['blog'] as List;
      blog_string = blog_data.map<Blog_Detail_list>(
              (json) => Blog_Detail_list.fromJson(json)).toList();


      setState(() {

        CategoryName=blog_string[0].CategoryName;
        Heading=blog_string[0].Heading;
        HText=blog_string[0].Text;
        PostDisplayPhoto=blog_string[0].PostDisplayPhoto;
        SubCategoryName=blog_string[0].SubCategoryName;
        PostImage1=blog_string[0].PostImage1;
        PostImage2=blog_string[0].PostImage2;
        PostImage3=blog_string[0].PostImage3;
        PostImage4=blog_string[0].PostImage4;
        PostImage5=blog_string[0].PostImage5;
        VideoLink=blog_string[0].VideoLink;
        ShareText=blog_string[0].ShareText;
        ShareLink=blog_string[0].ShareLink;
        TimeAgo=blog_string[0].TimeAgo;

        if(VideoLink!='')
        {
          videoId = YoutubePlayer.convertUrlToId("${VideoLink}")!;
          _controller = YoutubePlayerController(
            initialVideoId: '${videoId}',
            flags: YoutubePlayerFlags(
              autoPlay: false,
            ),
          );

        }


      });
    }
    else{
      //  Navigator.of(context).pop();
    }



  }

  @override
  Widget build(BuildContext context) {
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
                Text('${CategoryName}',
                    style:TextStyle(color: Colors.black,)),
              ],
            ),
            actions: [
              // Add any additional actions here
            ],
          ),

          body:       WillPopScope(
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 5),
                        Container(
                          height:MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          child:

                                YoutubePlayer(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                  showVideoProgressIndicator: true,

                                ),








                        ),





                      ],
                    ),
                  )
              )
          )

      );
  }
  Future _refreshData() async {
    GetBlogData();
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
class ImageScreen extends StatefulWidget {
  final String PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5;
  ImageScreen(this.PostDisplayPhoto,this.PostImage1,this.PostImage2,this.PostImage3,this.PostImage4,this.PostImage5);

  @override
  _MyImageScreen createState() => _MyImageScreen(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5);
}

class _MyImageScreen extends State<ImageScreen> {
  final String PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5;
  _MyImageScreen(this.PostDisplayPhoto,this.PostImage1,this.PostImage2,this.PostImage3,this.PostImage4,this.PostImage5);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white, // Change app bar color to white
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title:  Text(
          '',
          style:
          TextStyle(fontFamily: 'medium', fontSize: 18, color: Colors.white),
        ),

      ),
      body:     Container(
          height: screenHeight,
          color:Colors.white,
          child: Center(
            child: ListView(
              children: [
                CarouselSlider(
                  items: [


                    if(PostDisplayPhoto!='')...[

                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostDisplayPhoto}'),
                        ),
                      ),
                    ],


                    if(PostImage1!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostImage1}'),
                        ),
                      ),

                    ],



                    if(PostImage2!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostImage2}'),
                        ),
                      ),

                    ],

                    if(PostImage3!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostImage3}'),
                        ),
                      ),

                    ],
                    if(PostImage4!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostImage4}'),
                        ),
                      ),

                    ],
                    if(PostImage5!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'blog/${PostImage5}'),
                        ),
                      ),

                    ],

                  ],

                  //Slider Container properties
                  options: CarouselOptions(
                    height: 500.0,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,

                  ),
                ),
              ],
            ),
          )

      ),




    );

  }
}