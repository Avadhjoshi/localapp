import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/BlogDetail.dart';
import 'package:localapp/MoreScreen.dart';
import 'package:localapp/MyPostScreen.dart';
import 'package:localapp/component/logiin%20dailog.dart';
import 'package:localapp/constants/postPrivetType.dart';
import 'package:localapp/main.dart';
import 'package:localapp/models/UserCategory.dart';
import 'package:localapp/providers/location%20permission%20provider.dart';
import 'package:localapp/providers/notificationPermitionProvider.dart';
import 'package:localapp/providers/phoneNumberPerovider.dart';
import 'package:localapp/providers/profieleDataProvider.dart';
import 'package:logger/logger.dart';

import 'constants/DeviceHelper.dart';import 'package:shimmer/shimmer.dart';

import 'CityScreen.dart';
import 'HomeScreen.dart';
import 'JobScreen.dart';
import 'PostScreen.dart';
import 'constants/Config.dart';
import 'constants/DeviceHelper.dart';
import 'constants/prefs_file.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  ReceivedAction? initialAction;
  CategoryScreen({Key? key, this.initialAction}) : super(key: key);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen>
    with WidgetsBindingObserver {
  int selectedIdx = -1;
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = const Duration(milliseconds: 800);
  String status = '';
  String bg_image = '';

  List user_category_data = [];
  List<User_Category_list> user_category_string = [];

  String? _deviceId;

  bool _loaderShown = false;
  bool _isLoadingApi = false;
  void _showLoaderSafe() {
    if (_loaderShown) return;
    _loaderShown = true;
    showLoaderDialog(context);
  }

  void _hideLoaderSafe() {
    if (!_loaderShown) return;
    _loaderShown = false;
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  updatelatlong() async{

    var url = Config.update_Profile;
    String deviceId = await DeviceHelper.getDeviceId();
    Position location = await Geolocator.getCurrentPosition();

    http.Response response = await http.post(Uri.parse(url), body: {
      'PostById':'${deviceId}',
      "Latitude":location.latitude.toString(),
      "Longitude":location.longitude.toString(),



    });


    Map<String, dynamic> data = json.decode(response.body );
    bool status = data["success"];
    print('latlng${status}');


    if (status == true) {
    }
    else{

    }



  }

  Future<void> _ensureDeviceId() async {
    if (_deviceId != null) return;
    _deviceId = await DeviceHelper.getDeviceId();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    logger.w(state);
    ref.read(locationPermmissionProvider.notifier).checkDialog(context);
    ref.read(notificationPermissionProvider.notifier).checkDialog(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  int _currentIndexBottom = 0;
  Future<void> getUser() async {

      var url = Config.get_user;
      String? deviceId = _deviceId ?? await DeviceHelper.getDeviceId();
      _deviceId = deviceId;

      http.Response response = await http.post(
        Uri.parse(url),
        body: {'PostById': '$deviceId'},
      );

      if (kDebugMode) {
        logger.i("$url\n${response.statusCode}");
      }
    print('response.statusCode${response.statusCode}');
      if (response.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = json.decode(response.body);
      status = data["success"];

      if (status == "0") {
        print('mobile${data['data']['Name']}');
        if(data['data']['Name']!= null){
          Prefs prefs = new Prefs();

          await prefs.setuser_name(data['data']['Name']);

        }
        if (data['data']['Name'] == null ||
            data['data']['MobileNumber1'] == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => CustomDialog(),
            );
          });
        } else if (data['data']['Status'] == 'Rejected') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  showRejectedDialog(context, '${data['customer_care']}'),
            );
          });
        }
      }

  }

  Future<void> myInit() async {
    await Future.wait([
      ref.read(notificationPermissionProvider.notifier).getNotification(context),
      ref.read(locationPermmissionProvider.notifier).getLocationPermmision(context),
      ref.read(phoneNumberProvider.notifier).requestPermission(),
    ]);
    updatelatlong();
    //ref.read(profileProvider.notifier).updateLocation(context);
  }
  // Track the current page index

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initialAction != null &&
          widget.initialAction?.payload != null &&
          widget.initialAction!.payload!["blog_id"] != null &&
          widget.initialAction!.payload!["blog_id"] != '' &&
          navigatorKey.currentContext != null) {
        if (widget.initialAction!.payload!['type_id'] == "Category") {
          logger.f("initialAction: ${widget.initialAction?.payload}");
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                  '',
                  '',
                  widget.initialAction!.payload!["blog_id"] ?? "",
                  CategoryPrivacyType.public,
                  "",
                  widget.initialAction!.payload!["category_label"],
                  widget.initialAction!.payload!["SubSubCategoryLabel"],

                )),
          );
        } else {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(
                  widget.initialAction!.payload!["blog_id"] ?? "",
                  "",
                  "",
                  false),
            ),
          );
        }
      }
    });
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _ensureDeviceId();
    // Run permission checks without blocking data loading
    // (no await here on purpose)
    myInit();
    await _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() {
      showShimmer = true;
    });

      await Future.wait([
        getUser(),
        getUserCategory(),
      ]);


    if (!mounted) return;
    setState(() {
      showShimmer = false;
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
                child: Image.asset(
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

  Future<void> getUserCategory() async {

    try {
      var url = Config.get_category;
      String? deviceId = _deviceId ?? await DeviceHelper.getDeviceId();
      _deviceId = deviceId;

      http.Response response =
      await http.post(Uri.parse(url), body: {'user_id': deviceId});

      if (kDebugMode) {
        logger.i("$url\n${response.statusCode}");
      }
      print('statusCode${response.statusCode}');

      if (response.statusCode != 200) {
       // _hideLoaderSafe();
        return;
      }

      Map<String, dynamic> data = json.decode(response.body);
      status = data["success"];

      if (status == "0") {
        user_category_data = data['data']['category'] as List;
        user_category_string = user_category_data
            .map<User_Category_list>(
                (json) => User_Category_list.fromJson(json))
            .toList();

        setState(() {
          bg_image = data['data']['bg_image'];
        });
      }
    } catch (e) {
      debugPrint('getUserCategory error: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(5.0), // here the desired height
          child: AppBar(
            backgroundColor:
            Colors.transparent, // Change app bar color to white
            automaticallyImplyLeading: false,
          )),

      body: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: RefreshIndicator(
            onRefresh: _refreshData,
            child: Stack(
              children: [
                Image.network(
                  '${Config.Image_Path}category/$bg_image',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //

                        const SizedBox(height: 120),
                        for (int i = 0;
                        i < user_category_string.length;
                        i++) ...[
                          //card That Showing That Page
                          GestureDetector(
                            onTap: () {
                              logger.e(
                                  'Nuimber (${user_category_string[i].categoryId})');

                              // insertLog(context, deviceId: ref.read(profileProvider)?.deviceId??"", id: user_category_string[i].categoryId, type: InsertLogType.category);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        user_category_string[i]
                                            .whatsappText,
                                        user_category_string[i]
                                            .whatsappNumber,
                                        user_category_string[i].categoryId,
                                        user_category_string[i].privacyType,

                                        user_category_string[i]
                                            .privacyImage,
                                        user_category_string[i]
                                            .categoryLabel,
                                        user_category_string[i]
                                            .subSubCategoryLabel,
                                      )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  child: showShimmer
                                      ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8.0),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 12.0,
                                                  color: Colors.grey[300],
                                                ),
                                                const SizedBox(
                                                    height: 8.0),
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
                                  )
                                      : Column(
                                    children: [
                                      CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          imageUrl:
                                          '${Config.Image_Path + 'category/' + user_category_string[i].categoryImage}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              )),
                                      if (kDebugMode)
                                        Text(
                                            "p ${user_category_string[i].privacyType}  ${user_category_string[i].categoryId}")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                      ],
                    ))
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndexBottom,
        onTap: (int index) {
          setState(() {
            _currentIndexBottom = index;
            if (_currentIndexBottom == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()));
            }
            if (_currentIndexBottom == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CityScreen()));
            }

            if (_currentIndexBottom == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPostScreen(false)));
            }
            if (_currentIndexBottom == 3) {
              // showCustomPopup(context,'','','','');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MoreScreen()));
            }
          });
        },
        selectedItemColor: Colors.blue, // Set the selected item color to white
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
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
    Future.delayed(const Duration(milliseconds: 8), () {
      getUserCategory();
    });
  }
}


class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  Prefs prefs = new Prefs();
  updateUser(String name,String mobileNumber1) async{
    print('in updateUser');
    var url = Config.update_Profile;
    String deviceId = await DeviceHelper.getDeviceId();
    Position location = await Geolocator.getCurrentPosition();

    http.Response response = await http.post(Uri.parse(url), body: {
      'PostById':'${deviceId}',
      "Name":name,
      "MobileNumber1":mobileNumber1,
      "Latitude":location.latitude.toString(),
      "Longitude":location.longitude.toString(),



    });

  logger.i("$url\n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body );
    bool status = data["success"];
    print('aaaaaaaa${status}');


    if (status == true) {
      await prefs.setuser_name(name);

      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CategoryScreen()));
    }
    else{

    }



  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,  // Disable back button
        child:

        Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'For us to show you relevant information, we need to know you better.',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Name label
                Text(
                  'Your Name',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Name TextField
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Type Your Name here',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // WhatsApp label
                Text(
                  '10 Digit Whatsapp Number',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // WhatsApp TextField
                TextField(
                  controller: whatsappController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '10 Digit Whatsapp Number',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                // Info Text
                SizedBox(height: 4),
                Text(
                  'This Whatsapp number will NOT be visible to other users in the app. It is solely used for creating your profile.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // updateUser(nameController.text,whatsappController.text);
                      final name = nameController.text.trim();
                      final whatsapp = whatsappController.text.trim();

                      // Basic validation
                      if (name.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter your name',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }

                      if (whatsapp.isEmpty || whatsapp.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(whatsapp)) {
                        Fluttertoast.showToast(
                          msg: 'Please enter a valid 10-digit WhatsApp number',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;

                      }

                      updateUser(name, whatsapp);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 1,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

}

Widget showRejectedDialog(BuildContext context, String custCareNumber) {
  final screenWidth = MediaQuery.of(context).size.width;
  final textScale = MediaQuery.of(context).textScaleFactor;

  return WillPopScope(
    onWillPop: () async => false, // Disable back button
    child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: screenWidth * 0.85, // 85% of screen width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Your Profile is\nRejected by Admin!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22 * textScale, // scales with screen size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Please contact Local App\nAdmin at -',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16 * textScale,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final number = 'tel:$custCareNumber';
                  if (await canLaunchUrl(Uri.parse(number))) {
                    await launchUrl(Uri.parse(number));
                  }
                },
                child: Text(
                  custCareNumber,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18 * textScale,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
