import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:localapp/ImagePickerPage.dart';
import 'package:localapp/VideoPlayer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'AddPost1Screen.dart';
import 'AddPost2Screen.dart';
import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'MultiImagePicker.dart';
import 'constants/Config.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/models/BlogList.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'constants/prefs_file.dart';
import 'image_viewer.dart';
import 'models/BlogDetailList.dart';
import 'models/LocalAd.dart';
import 'package:shimmer/shimmer.dart';
class AddPostScreen extends StatefulWidget {
  String CategoryId;
  AddPostScreen(this.CategoryId);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);
  String DescriptionPlaceholder='';
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

  List category_data = [];
  List<Category_list> category_string=[];
  String CategoryName='';
  int _currentIndex=0;

  String CategoryId='';
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
  String PostSubCategory='';
  String VideoLink='';
  String ShareText='';
  String WhatsappNumber='';
  String WhatsappText='';
  String ShareLink='';
  String videoId='';
  HtmlEditorController html_controller = HtmlEditorController();

  TextEditingController desc_con = new TextEditingController();
  Prefs prefs = new Prefs();

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
  List<File> _selectedImages = [];


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () {
      GetApiData();
     // get_desc();
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
      GetApiData();
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
    // GetApiData();

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

  GetApiData() async{
    //showLoaderDialog(context);
    var url = Config.get_category_data;

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id':'${widget.CategoryId}',
    });



    Map<String, dynamic> data = json.decode(response.body );
    logger.i("$url\n ${response.statusCode} \n${data}");
    status = data["success"];
    print('data${data}');


    if (status == "0") {
      // Navigator.of(context).pop();

      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data.map<Category_list>(
              (json) => Category_list.fromJson(json)).toList();


      setState(() {

        CategoryName=categorylist_string[0].CategoryName;
        DescriptionPlaceholder=categorylist_string[0].DescriptionPlaceholder==null?'Enter your text here...':categorylist_string[0].DescriptionPlaceholder;
          //DescriptionPlaceholder=categorylist_string[0].DescriptionPlaceholder;


      });
    }
    else{
      //  Navigator.of(context).pop();
    }



  }
  get_desc() async {
    String recent_desc = await prefs.getpost_desc();
    print('selected_catid${widget.CategoryId}');
    if (recent_desc != '') {
      desc_con.text = _storeText('${recent_desc}');
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
              // Add spacing between the image and text
              Text('${CategoryName}',
                  style:TextStyle(color: Colors.black,)),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: (){
                if(desc_con.text=='')
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog("Fill all the required information first and then submit.");
                    },
                  );

                }
                else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost2Screen('${widget.CategoryId}', '${_storeText(desc_con.text)}', _selectedImages,'')));
                }

              },
              child:  SizedBox(
                height: 20, // Adjust height as needed
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    color:Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),

                  child: Center(
                    child:  Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Adjust font size as needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                          padding: EdgeInsets.all(16.0),
                          child:

                          TextField(
                            autofocus:true,
                           controller: desc_con,
                           maxLines: null, // Allows unlimited lines
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,

                            decoration: InputDecoration(
                              hintText: '${DescriptionPlaceholder}',
                              border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintMaxLines: 4
                            ),
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),





                      ],
                    ),
                  )
              )
          ),


      floatingActionButton:GestureDetector(onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddPost1Screen('${widget.CategoryId}','${_storeText(desc_con.text)}')));
       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  ImagePickerPage()));
      },
          child:  Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
             "assets/images/picture_icon.png",
              height: 50,
              width: 50,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

    );
  }
   _storeText(String text) {
    // Replace new lines with appropriate representation before saving to database
    String sanitizedText = text.replaceAll('\n', '\\n');
    // Simulate storing to database
   return sanitizedText;

  }
  Future _refreshData() async {
    GetApiData();
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
