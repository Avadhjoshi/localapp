import 'dart:convert';

import 'package:flutter/material.dart';

import 'CategoryScreen.dart';
import 'CityScreen.dart';
import 'MyPostScreen.dart';
import 'VideoPlayerScreen.dart';
import 'constants/Config.dart';
import 'constants/prefs_file.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:platform_device_id/platform_device_id.dart';

class MoreScreen extends StatefulWidget {
  
  MoreScreen();

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Prefs prefs = new Prefs();
  late String? DeviceId='';
  int _currentIndexBottom=3;
  String status='';
  String CustomerCare='';
  String CustomerCareMsg='';
  String TutorialVideo='';
  String TermsCondition='';
  String videoId='';
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () {
      get_name();
      getApi();
    });

    super.initState();
  }
  get_name() async{
   String? device_Id = await PlatformDeviceId.getDeviceId;

   setState(() {
      DeviceId=device_Id;
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

  getApi() async{
    showLoaderDialog(context);
    var url = Config.get_setup;

    http.Response response = await http.post(Uri.parse(url), body: {
    });
    logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    print('data${data}');
    status = data["success"];
    print('setup${data["data"]}');

    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();

      });
      setState(() {

        CustomerCare= data["data"]["setup"][0]['Cust_Care_Num']==null?'':data["data"]["setup"][0]['Cust_Care_Num'];
        CustomerCareMsg=data["data"]["setup"][0]['Cust_Care_Message']==null?'':data["data"]["setup"][0]['Cust_Care_Message'];
        TutorialVideo=data["data"]["setup"][0]['Long_Video_Link']==null?'':data["data"]["setup"][0]['Long_Video_Link'];
        TermsCondition=data["data"]["setup"][0]['Terms_Condition']==null?'':data["data"]["setup"][0]['Terms_Condition'];
        videoId = YoutubePlayer.convertUrlToId("${TutorialVideo}")!;


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
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the background color to white
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen())),
        ),

        title: Text(
          'More',
          style: TextStyle(color: Colors.black), // Set the text color to black
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set the leading arrow color to black
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '${DeviceId}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          /*ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Edit current City/Area'),
            onTap: () {
              // Add your navigation logic here
            },
          ),
          Divider(),*/
          ListTile(
            leading: Icon(Icons.play_circle_filled),
            title: Text('Tutorial Video'),
            onTap: () {
              // Add your navigation logic here
              launchUrl("${TutorialVideo}");

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.headset_mic),
            title: Text('Customer Care'),
            onTap: () {
              launchUrl("https://wa.me/+91${CustomerCare}?text=${CustomerCareMsg}");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms & Conditions'),
            onTap: () {
              // Add your navigation logic here
              launchUrl("${TermsCondition}");
            },
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoId: videoId),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.network(
                    'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 72.0,
                  ),
                ],
              ),
            ),
          ),

        ],
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
