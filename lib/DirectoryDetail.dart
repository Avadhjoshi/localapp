import 'dart:async';
import 'package:share_plus/share_plus.dart';

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
import 'package:platform_device_id/platform_device_id.dart';

import 'image_viewer.dart';
import 'models/DirectoryList.dart';
import 'models/LocalAd.dart';
import 'package:shimmer/shimmer.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class DirectoryDetailScreen extends StatefulWidget {
  String ContactId;
  String PostCategory;
  String PostSubCategory;
  DirectoryDetailScreen(this.ContactId,this.PostCategory,this.PostSubCategory);

  @override
  _DirectoryDetailScreenState createState() => _DirectoryDetailScreenState();
}

class _DirectoryDetailScreenState extends State<DirectoryDetailScreen> {
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
  List<Directory_list> directory_string=[];
  String CategoryName='';
  int _currentIndex=0;

  String ContactId='';
  String Description='';
  String ShortDesc='';
  String FullName='';
  String WhatsappNumber='';
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
  String CallingNumber='';
  String AlternateNumber='';
  String ServiceRange='';
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
      GetContactData();
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
      GetContactData();
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
    // GetContactData();

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

  GetContactData() async{
    showLoaderDialog(context);
    var url = Config.get_directory_data;
    print('selected_category${widget.PostCategory}');
    print('selected_sub_category${widget.PostSubCategory}');
    print('post_id${widget.ContactId}');
    String? deviceId = await PlatformDeviceId.getDeviceId;

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${widget.PostCategory}',
      'subcategory_id':'${widget.PostSubCategory}',
      'contact_id':'${widget.ContactId}',
      'user_id':'${deviceId}'
    });

    logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    status = data["success"];
    print('status${status}');


    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
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
      directory_string = blog_data.map<Directory_list>(
              (json) => Directory_list.fromJson(json)).toList();


      setState(() {

        WhatsappNumber=directory_string[0].WhatsappNumber;
        Description=directory_string[0].Description;
        PostDisplayPhoto=directory_string[0].DisplayPhoto;
        ShortDesc=directory_string[0].ShortDesc;
        FullName=directory_string[0].FullName;
        PostImage1=directory_string[0].Photo1;
        PostImage2=directory_string[0].Photo2;
        PostImage3=directory_string[0].Photo3;
        PostImage4=directory_string[0].Photo4;
        PostImage5=directory_string[0].Photo5;
        TimeAgo=directory_string[0].TimeAgo;
        CallingNumber=directory_string[0].CallingNumber==null?'':directory_string[0].CallingNumber;
        WhatsappNumber=directory_string[0].WhatsappNumber==null?'':directory_string[0].WhatsappNumber;
        AlternateNumber=directory_string[0].AlternateNumber==null?'':directory_string[0].AlternateNumber;
        ServiceRange=directory_string[0].ServiceRange==null?'':directory_string[0].ServiceRange;
        SubCategoryName=directory_string[0].SubCategoryName==null?'':directory_string[0].SubCategoryName;
        CategoryName=directory_string[0].CategoryName==null?'':directory_string[0].CategoryName;

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
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          backgroundColor: Colors.white,
          appBar:AppBar(
            backgroundColor: Colors.white, // Change app bar color to white
            elevation: 0.0, // Remove the bottom border
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
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
                Container(
                  width: 300,
                  child:   Text('${FullName}',
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(color: Colors.black,)),
                )//
              ],
            ),
            actions: [
              // Add any additional actions here
            ],
          ),

          body:       WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop();
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
                          color: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              if(VideoLink!='')...[

                                YoutubePlayer(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                ),

                              ]     else...[


                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,0,'directory_contact')));


                                  },
                                  child:

                                  showShimmer
                                      ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 380,
                                      color: Colors.white,
                                    ),
                                  )
                                      :
                                  Container(
                                    color:Colors.white,
                                    alignment: Alignment.center,
                                    child:
                                    CachedNetworkImage(
                                      imageUrl:Config.Image_Path+'directory_contact/${PostDisplayPhoto}',
                                    ),

                                  ),
                                )


                              ],
                              SizedBox(height: 10.0),
                              Center(
                                child:    Row(
                                  children: [

                                    if(VideoLink!='')...[
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 380,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      Image.network(Config.Image_Path+'directory_contact/${PostDisplayPhoto}',
                                        width: MediaQuery.of(context).size.width/6.5,
                                        height: 80,
                                        fit: BoxFit.cover,),


                                    ],
                                    if(PostImage1!='')...[

                                      SizedBox(width: 10),
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,1,'directory_contact')));


                                        },
                                        child:
                                        CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width/6.5,
                                            height: 80,

                                            imageUrl:Config.Image_Path+'directory_contact/${PostImage1}',
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



                                    ],
                                    if(PostImage2!='')...[
                                      SizedBox(width: 10),
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,2,'directory_contact')));


                                        },
                                        child:
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width/6.5,
                                          height: 80,

                                          imageUrl:Config.Image_Path+'directory_contact/${PostImage2}',
                                          placeholder: (context, url) =>Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,


                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                      )
                                    ],
                                    if(PostImage3!='')...[

                                      SizedBox(width: 10),
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,3,'directory_contact')));


                                        },
                                        child:
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width/6.5,
                                          height: 80,

                                          imageUrl:Config.Image_Path+'directory_contact/${PostImage3}',
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
                                        ),
                                      )
                                    ],
                                    if(PostImage4!='')...[

                                      SizedBox(width: 10),
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,4,'directory_contact')));


                                        },
                                        child:
                                        CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width/6.5,
                                          height: 80,

                                          imageUrl:Config.Image_Path+'directory_contact/${PostImage4}',
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

                                    ],
                                    if(PostImage5!='')...[

                                      SizedBox(width: 10),
                                      showShimmer
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                          :
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,5,'directory_contact')));


                                        },
                                        child:
                                        CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width/6.5,
                                            height: 80,

                                            imageUrl:Config.Image_Path+'directory_contact/${PostImage5}',
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

                                    ],
                                  ],

                                ),
                              ),
                              SizedBox(height: 10),
                              showShimmer
                                  ?
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                ),
                              )
                                  :  Container(
                                padding: const EdgeInsets.only(left:15),

                                child:  Text('${FullName}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                ),
                              ),
                              SizedBox(height: 2),

                              showShimmer
                                  ?
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                ),
                              )
                                  :  Container(
                                padding: const EdgeInsets.only(left:15),

                                child:  Text('${SubCategoryName}',  style: TextStyle(color: Colors.blue),),
                              ),
                              SizedBox(height: 10,),
                              showShimmer
                                  ?
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                ),
                              )
                                  :  Container(
                                padding: const EdgeInsets.only(left:15),

                                child:    Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on, // Map pin icon
                                      color: Colors.black, // Optional: Set the color of the icon
                                      size: 15, // Optional: Set the size of the icon
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 200,
                                      child:  Text(
                                        '${ServiceRange}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // Add spacing between the icon and text
                                  ],
                                ),

                              ),
                              if(Description!='')...[
                                SizedBox(height: 10.0),
                                showShimmer
                                    ?
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child:
                                  Container(
                                      height: 300,
                                      child:  ListView.builder(
                                        itemCount: 5, // Number of lines
                                        itemBuilder: (context, index) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                              width: double.infinity,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                  ),

                                )
                                    :
                                Container(
                                  padding: const EdgeInsets.only(left:10),
                                  child:  Html(
                                    data:'${Description}',
                                    onLinkTap: (url, _, __, ___) async {
                                      if (await canLaunch(url!)) {
                                        await launch(
                                          url,
                                        );
                                      }
                                    },

                                  ),
                                ),
                              ]else...[
                                  SizedBox(height: 10.0),
                                  showShimmer
                                      ?
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child:
                                    Container(
                                        height: 300,
                                        child:  ListView.builder(
                                          itemCount: 5, // Number of lines
                                          itemBuilder: (context, index) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                width: double.infinity,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                    ),

                                  )
                                      :
                                  Container(
                                    padding: const EdgeInsets.only(left:10),
                                    child:  Html(
                                      data:'${ShortDesc}',
                                      onLinkTap: (url, _, __, ___) async {
                                        if (await canLaunch(url!)) {
                                          await launch(
                                            url,
                                          );
                                        }
                                      },

                                    ),
                                  ),

                              ],

                              if(ShareText!='')...[
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        launchUrl(ShareLink);
                                        // Add your button click logic here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        backgroundColor: Colors.black, // Set the background color to black
                                      ),
                                      child:
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                                        child:
                                        Text(
                                          '${ShareText}',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),


                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child:    Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.grey,
                                            size: 16.0,
                                          ),
                                          SizedBox(width: 5.0),
                                          Text(
                                            '${TimeAgo}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ]






                            ],
                          ),
                        ),





                      ],
                    ),
                  )
              )
          ),

        bottomNavigationBar:

        Container(
          margin: EdgeInsets.all(10.0),

          child:  Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
            ),
            elevation: 4,

            child:Container(
              height: 40,

              margin: EdgeInsets.all(10.0),

              child:     Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){

                      launchUrl("tel://${CallingNumber}");
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

                      launchUrl("https://wa.me/+91${WhatsappNumber}");
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

                      String msg="This contact is shared from Local App.\n*Name:* ${FullName}\n*Contact Number:* ${CallingNumber}\n ${CategoryName} - ${SubCategoryName}";
                      Share.share('${msg}',
                          subject: 'Local App');
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

            ),

          ),
        ),

      );
  }
  Future _refreshData() async {
    GetContactData();
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
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostDisplayPhoto}'),
                        ),
                      ),
                    ],


                    if(PostImage1!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostImage1}'),
                        ),
                      ),

                    ],



                    if(PostImage2!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostImage2}'),
                        ),
                      ),

                    ],

                    if(PostImage3!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostImage3}'),
                        ),
                      ),

                    ],
                    if(PostImage4!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostImage4}'),
                        ),
                      ),

                    ],
                    if(PostImage5!='')...[
                      Container(
                        color:Colors.white,
                        child:
                        PhotoView(
                          imageProvider:NetworkImage(Config.Image_Path+'directory_contact/${PostImage5}'),
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