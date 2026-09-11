import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/APIs/inselLog%20Method.dart';
import 'package:localapp/CategoryScreen.dart';
import 'package:localapp/constants/postPrivetType.dart';
import 'package:localapp/models/BlogList.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'package:localapp/models/insertLogType.dart';
import 'package:localapp/providers/profieleDataProvider.dart';
import 'package:localapp/providers/subSub%20Catoge.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/DeviceHelper.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'AddPostScreen.dart';
import 'BlogListWidget.dart';
import 'CityScreen.dart';
import 'InternetLostScreen.dart';
import 'MoreScreen.dart';
import 'MyPostScreen.dart';
import 'constants/Config.dart';
import 'features/home/widgets/group_preview_tile.dart';
import 'features/home/widgets/group_tile.dart';
import 'models/City.dart';
import 'models/LocalAd.dart';
import 'models/SubSubCategory.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String catPrivacyType;
  final String? privacyImage;
  final String? CategoryLabel;
  final String? subSubCategoryLabel;
  final String? whatsAppText;
  String CategoryId;
  final String? whatsAppNumber;
  HomeScreen(this.whatsAppText, this.whatsAppNumber, this.CategoryId,
      this.catPrivacyType,
      this.privacyImage, this.CategoryLabel,this.subSubCategoryLabel);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIdx = 0;
  int blog_page = 0;
  int total_page = 0;
  bool load_more = true;
  bool hide_appbar = false;
  String status = '';
  String notification_popup = '';
  int selected_category = 0;
  int selected_sub_category = 0;
  int selected_sub_sub_category = 0;
  String allow_post = '';

  String app_version = '';
  String current_app_version = '20';
  String category_label = '';
  String subSubCategoryLabel = "";
  bool filter_selected = false;
  String category_name = '';
  String? whatsAppText;

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List sub_sub_categorylist_data = [];
  List<SubSubCategory_list> sub_sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];

  List notification_ad_data = [];
  List<LocalAd_list> notification_ad_string = [];

  List blog_data = [];
  List<Blog_list> blog_string = [];
  List<Blog_list> blog_string_list = [];

  List city_data = [];
  List<City_list> city_string = [];

  var apun_Ka_Dat;

  final navigatorKey = GlobalKey<NavigatorState>();
  late ScrollController _scrollController;
  late Future<void> _loadDataFuture;
// 🔹 Dummy users (Group preview)
  List<String> dummyNames = [];
  List<String> dummyInitials = [];
  int dummyTotalMembers = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);

    _loadDataFuture = _initializeData(); // call immediately
  }

  Future<void> _initializeData() async {
    selected_category = int.tryParse(widget.CategoryId) ?? 0;
    _requestNotificationPermission();
    subSubCategoryLabel=widget.subSubCategoryLabel!;
    category_label=widget.CategoryLabel!;
    print('widget.subSubCategoryLabel${widget.subSubCategoryLabel!}');
    await getCity();
    await getHome();
  }


  Future<void> _requestNotificationPermission() async {
    print('_requestNotificationPermission');
    final PermissionStatus status = await Permission.notification.request();
    if (status == PermissionStatus.granted) {
      // Permission granted, you can proceed with using notifications
      print('Notification permission granted');
    } else {
      // Permission not granted, handle accordingly
      print('Notification permission not granted');
    }
  }

  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;
    if (Platform.isIOS) {
      //perm = await permissionPhotos();
    } else if (Platform.isAndroid) {
      // final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      // final int sdkInt = android.version.sdkInt ?? 0;
      // print('sdkInt${sdkInt}');
      // if (sdkInt > 32) {
      final PermissionStatus try1 = await Permission.photos.request();
      final PermissionStatus try2 = await Permission.camera.request();
      // } else {
      final PermissionStatus try3 = await Permission.storage.request();
      final PermissionStatus try4 = await Permission.camera.request();
      // }
    } else {}
    return Future<bool>.value(perm);
  }




  void _scrollListener() {
    if (_scrollController.offset > 0.0) {
      setState(() {
        hide_appbar = true;
      });
    } else if (_scrollController.offset == 0.0) {
      setState(() {
        hide_appbar = false;
      });
    }
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('total_page${total_page}');

      if (blog_page != total_page) {
        print('calledscrollListener');
        setState(() {
          blog_page++;
        });

        getMoreHome();
      }
    }
  }

  bool isInitialLoading = false;
  bool _loaderShown = false;

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

  Future<void> getHome() async {
    if (isInitialLoading) return;

    isInitialLoading = true;
    _showLoaderSafe();

    blog_page = 0;
    load_more = true;

    blog_data.clear();
    blog_string.clear();
    local_ad_data.clear();
    local_ad_string.clear();
    sub_categorylist_data.clear();
    sub_categorylist_string.clear();
    sub_sub_categorylist_string.clear();
    notification_ad_string.clear();

    try {
      final String deviceId = await DeviceHelper.getDeviceId();

      final response = await http
          .post(
        Uri.parse(Config.get_home),
        body: {
          'category_id': '$selected_category',
          'subcategory_id': '$selected_sub_category',
          'blog_page': '$blog_page',
          'user_id': '$deviceId',
          'city_id': '1',
          'subsubcategory_id': '${selected_sub_sub_category ?? 0}',
        },
      )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        _hideLoaderSafe();
        isInitialLoading = false;
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);
      status = data['success'];
      print('data$data');

      if (status != '0') {
        _hideLoaderSafe();
        isInitialLoading = false;
        return;
      }

      final d = data['data'];
      apun_Ka_Dat = data;

      // ---------- CATEGORY ----------
      categorylist_string = (d['category'] as List)
          .map((e) => Category_list.fromJson(e))
          .toList();

      if (selected_category == 0 && categorylist_string.isNotEmpty) {
        selected_category = int.parse(categorylist_string[0].CategoryId);
      }

      // ---------- SUB CATEGORY ----------
      sub_categorylist_string = (d['sub_category'] as List)
          .map((e) => SubCategory_list.fromJson(e))
          .toList();

      // ----------SUB SUB CATEGORY ----------
      sub_sub_categorylist_string = (d['sub_sub_category'] as List)
          .map((e) => SubSubCategory_list.fromJson(e))
          .toList();

      // ---------- ADS ----------
      local_ad_string = (d['local_ad'] as List)
          .map((e) => LocalAd_list.fromJson(e))
          .toList();

      // ---------- BLOGS ----------
      blog_string = (d['blog'] as List)
          .map((e) => Blog_list.fromJson(e))
          .toList();

      // ---------- NOTIFICATION ADS ----------
      /*notification_ad_string = (d['local_ad_notification'] as List)
          .map((e) => LocalAd_list.fromJson(e))
          .toList();*/

      // ---------- META ----------
      total_page = d['total_page'] ?? 0;
      allow_post = d['allow_post'] ?? '';
      if (!filter_selected) {
        category_label = d['category_label'] ?? '';
      }
// ---------- DUMMY USERS ----------
      if (d['dummy_users'] != null) {
        dummyNames = List<String>.from(d['dummy_users']['names'] ?? []);
        dummyInitials = List<String>.from(d['dummy_users']['initials'] ?? []);
        dummyTotalMembers = d['dummy_users']['total_members'] ?? 0;
      }

      category_name = d['category_name'] ?? '';
      app_version = d['last_app_version'] ?? '1';

      _hideLoaderSafe();

      // ---------- POPUPS ----------
      if (app_version != current_app_version) {
        //updateAppDialog(context);
      } else if (notification_ad_string.isNotEmpty) {
        showCustomPopup(
          context,
          notification_ad_string[0].AdImage,
          notification_ad_string[0].WhatsappNumber,
          notification_ad_string[0].WhatsappText,
          notification_ad_string[0].Url,
          notification_ad_string[0].AdId,
        );
      }
    } catch (e) {
      debugPrint('getHome error: $e');
      _hideLoaderSafe();
    }

    isInitialLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateAppDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateAlertDialog(
          message:
          'A new version of the app is available.Please update for the best experience.',
          appStoreUrl:
          'https://play.google.com/store/apps/details?id=com.memento.localapp', // Replace with your app store URL
        );
      },
    );
  }

  RetryPopup() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch data. Retry?'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                getHome(); // Retry fetching data
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  apnaDailog() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text("$apun_Ka_Dat")));
  }

  getMoreHome() async {
    print('get_home_called${blog_page}');

    showLoaderDialog(context);

    var url = Config.get_home;
    String deviceId = await DeviceHelper.getDeviceId();

    http.Response response = await http.post(Uri.parse(url), body: {
      'category_id': '${selected_category}',
      'blog_page': '${blog_page}',
      'user_id': '${deviceId}',
      'city_id': '1',
      'subsubcategory_id': '${selected_sub_sub_category ?? 0}'
    });

    logger.i(
        "$url \n${response?.statusCode} \n${jsonDecode(response.body ?? "")}");

    Map<String, dynamic> data = json.decode(response.body);
    status = data["success"];

    if (status == "0") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      categorylist_data = data['data']['category'] as List;
      categorylist_string = categorylist_data
          .map<Category_list>((json) => Category_list.fromJson(json))
          .toList();
      if (selected_category == 0) {
        selected_category = int.parse(categorylist_string[0].CategoryId);
      }
      sub_categorylist_data = data['data']['sub_category'] as List;
      sub_categorylist_string = sub_categorylist_data
          .map<SubCategory_list>((json) => SubCategory_list.fromJson(json))
          .toList();

      sub_sub_categorylist_data = data['data']['sub_sub_category'] as List;
      sub_sub_categorylist_string = sub_sub_categorylist_data
          .map<SubSubCategory_list>((json) => SubSubCategory_list.fromJson(json))
          .toList();

      local_ad_data = data['data']['local_ad'] as List;
      local_ad_string = local_ad_data
          .map<LocalAd_list>((json) => LocalAd_list.fromJson(json))
          .toList();

      blog_data = data['data']['blog'] as List;
      List<Blog_list> blog_string_data =
      blog_data.map<Blog_list>((json) => Blog_list.fromJson(json)).toList();

      setState(() {
        blog_string.addAll(blog_string_data);
        total_page =
        data['data']['total_page'] == null ? 0 : data['data']['total_page'];
        if (total_page == blog_page) {
          load_more = false;
        }
      });
    } else {
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


  getCity() async {
    var url = Config.get_city;

    http.Response response = await http.post(Uri.parse(url), body: {});
    // logger.i("$url \n${response.statusCode} \n${jsonDecode(response.body)}");

    Map<String, dynamic> data = json.decode(response.body);
    status = data["success"];
    print('status${status}');

    if (status == "0") {
      setState(() {
        city_data = data['data'] as List;
        city_string = city_data
            .map<City_list>((json) => City_list.fromJson(json))
            .toList();
        print('city_string${data}');
      });
    } else {}
  }

  void selectItem(int index, String cat_id) {
    setState(() {
      print('selectedIdx${selectedIdx}');

      print('index${index}');

      selected_category = int.parse(cat_id);
      selectedIdx_2 = 0;
      selected_sub_category = 0;
      getHome();
      //getSubCategory();

      /*if (index == selectedIdx) {
          // If the same item is tapped again, clear the selection
          selectedIdx = 0;
        } else {*/
      selectedIdx = index;
      //}
    });
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

  void onItemClicked(int index, String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category = int.parse(subcat_id);
    });
    print('selected_sub_category${selected_sub_category}');
    getHome();
    //getSubCategory();
  }

  int _currentIndex = 0; // Track the current page index
  int _currentIndexBottom = 0; // Track the current page index

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  ad_response(ad_id) async {
    var url = Config.insert_ad_response;
    String deviceId = await DeviceHelper.getDeviceId();
    print('deviceId${deviceId}');
    print('ad_id${ad_id}');
    http.Response response = await http.post(Uri.parse(url),
        body: {"user_id": '${deviceId}', "ad_id": '${ad_id}'});

    // logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");
  }

  final dropDownInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.black,
    ),
  );

  RangeValues values = RangeValues(15, 15);


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Change app bar color to white
        leadingWidth: 50.0, // Adjust this width as needed

        elevation: 0.0, // Remove the bottom border
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.read(subSubCategoryProvider.notifier).clean();
            Navigator.of(context).pop();
          },
        ),

        iconTheme:
        IconThemeData(color: Colors.black), // Change icon color to black
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.black), // Change text color to black
        // ),

        centerTitle: true,
        title: hide_appbar == false
            ? Row(
          children: [
            Text(category_name,
                style: const TextStyle(color: Colors.black)),
          ],
        )
            : GestureDetector(
          onTap: () {
            _showCategoryPopup(context);
            setState(() {
              filter_selected = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  '${category_label}',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Spacer(),
                if (filter_selected == true) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        category_label = '';
                        filter_selected = false;
                        selected_sub_category = 0;
                        selected_sub_sub_category = 0;
                        ref.read(subSubCategoryProvider.notifier).clean();
                      });
                      Future.delayed(Duration(milliseconds: 1), () {
                        getHome();
                      });
                    },
                    child: Image.asset(
                      'assets/images/crossicon.png',
                      height: 20.0,
                      width: 20.0,
                      // adjust height and width according to your image size
                    ),
                  )
                ] else ...[
                  Image.asset(
                    'assets/images/Dropdownicon.png',
                    height: 20.0,
                    width: 20.0,
                    // adjust height and width according to your image size
                  ),
                ]
              ],
            ),
          ),
        ),

        actions: [],
        bottom: hide_appbar == false
            ? PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: GestureDetector(
            onTap: () {
              _showCategoryPopup(context);
              setState(() {
                filter_selected = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '${category_label}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(),
                  if (filter_selected == true) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          category_label = '';
                          filter_selected = false;
                          selected_sub_category = 0;
                          selected_sub_sub_category = 0;

                        });
                        Future.delayed(Duration(milliseconds: 1), () {
                          getHome();
                        });
                      },
                      child: Image.asset(
                        'assets/images/crossicon.png',
                        height: 20.0,
                        width: 20.0,
                        // adjust height and width according to your image size
                      ),
                    )
                  ] else ...[
                    Image.asset(
                      'assets/images/Dropdownicon.png',
                      height: 20.0,
                      width: 20.0,
                      // adjust height and width according to your image size
                    ),
                  ]
                ],
              ),
            ),
          ),
        )
            : PreferredSize(
            preferredSize: Size.fromHeight(0.0), child: Container()),
      ),

      body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => CategoryScreen()),
                  (route) => false,
            );
            return false;
          },
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              controller: _scrollController,
              children: [
                if(filter_selected==true)...[

                PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: GestureDetector(
                    onTap: () {
                      _showSubSubCategoryPopup(context);
                      setState(() {
                       // filter_selected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            '${subSubCategoryLabel}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Spacer(),
                          if (filter_selected == true) ...[
                            GestureDetector(
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 1), () {
                                  getHome();
                                });
                              },
                              child: Image.asset(
                                'assets/images/crossicon.png',
                                height: 20.0,
                                width: 20.0,
                                // adjust height and width according to your image size
                              ),
                            )
                          ] else ...[
                            Image.asset(
                              'assets/images/Dropdownicon.png',
                              height: 20.0,
                              width: 20.0,
                              // adjust height and width according to your image size
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                ],
                if(dummyTotalMembers>0)...[
                Container(
                  height: 70,
                  child:
                 /* GroupPreviewTile(
                      groupName: category_name,
                      initials: dummyInitials,
                      titleText: dummyNames.join(', '), // "test, best"
                      suffixText: 'and ${dummyTotalMembers }+ active members.'
                    ),*/
                  GroupPreviewTileNew(
                    initials: dummyInitials,
                    titleText: dummyNames.join(', '), // "test, best"
                    membersOnline: "${dummyTotalMembers}",
                  )
                  ),
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (local_ad_string.length == 1) ...[
                      GestureDetector(
                          onTap: () {
                            ad_response(local_ad_string[0].AdId);
                            String w_no = local_ad_string[0].WhatsappNumber;
                            String w_msg = local_ad_string[0].WhatsappText;
                            String url =
                                "https://wa.me/+91${w_no}?text=${w_msg}";
                            if (local_ad_string[0].Url != '') {
                              url = local_ad_string[0].Url;
                            }

                            launchUrl(url);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              imageUrl: Config.Image_Path +
                                  'local_ad/' +
                                  local_ad_string[0].AdImage,
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
                          ))
                    ],
                    if (local_ad_string.length > 1) ...[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height / 2,
                          enlargeCenterPage: false,
                          autoPlay: false,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          onPageChanged:
                          onPageChanged, // Add the onPageChanged callback
                        ),
                        items: local_ad_string.map((LocalAd_List) {
                          int index = local_ad_string
                              .indexOf(LocalAd_List); // Get the index

                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        ad_response(
                                            local_ad_string[index].AdId);

                                        String w_no = local_ad_string[index]
                                            .WhatsappNumber;
                                        String w_msg =
                                            local_ad_string[index].WhatsappText;
                                        String url =
                                            "https://wa.me/+91${w_no}?text=${w_msg}";
                                        if (local_ad_string[index].Url != '') {
                                          url = local_ad_string[index].Url;
                                        }

                                        launchUrl(url);
                                      },
                                      child: CachedNetworkImage(
                                        fadeInDuration: Duration.zero,
                                        fadeOutDuration: Duration.zero,
                                        imageUrl: Config.Image_Path +
                                            'local_ad/' +
                                            local_ad_string[index].AdImage,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                      )));
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    if (local_ad_string.length > 1) ...[
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
                              color: index == _currentIndex
                                  ? Colors.blue
                                  : Colors
                                  .grey, // Change color based on current page index
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: blog_string.length +
                          1, // +1 for the loading indicator
                      itemBuilder: (context, index) {
                        if (index == blog_string.length) {
                          if (load_more == true)
                            return _buildLoadingIndicator();
                        } else {
                          return BlogListWidget(
                            blog_string[index],
                            '${selected_category}',
                            '${selected_category}',
                            privecyType: widget.catPrivacyType,
                            privacyImage: widget.privacyImage,
                            whatsAppNumber: widget.whatsAppNumber,
                            whatsAppText: widget.whatsAppText,
                          );
                          // return Card(margin: EdgeInsets.all(10),color: Colors.grey,
                          //     child: Text("${blog_string[index].toJson()["PostByName"]}")
                          // );
                        }
                      },
                    ),
                    if (blog_string.length > 0) ...[
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/BottomImage.png',
                          fit: BoxFit
                              .fill, // Adjust this according to your needs
                        ),
                      )
                    ]
                  ],
                ),
              ],
            ),
          )),

      //Orignal Button
      floatingActionButton: Consumer(
        builder: (context2, ref, child) {
          var profile = ref.read(profileProvider);
          if (allow_post == 'Y') {
            return FloatingActionButton(
              onPressed: () {
                // Logger().e('${profile!.groupAccess}');

                if ((widget.catPrivacyType != CategoryPrivacyType.private &&
                    widget.catPrivacyType !=
                        CategoryPrivacyType.semiPrivate) ||
                    profile!.groupAccess
                        .toString()
                        .split(",")
                        .contains(widget.CategoryId)) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddPostScreen('${selected_category}')));
                } else {
                  showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        content: InkWell(
                            onTap: () {
                              logger.t(
                                  "${widget.whatsAppNumber} (${widget.whatsAppText})");
                              if (widget.whatsAppNumber
                                  .toString()
                                  .isNotEmpty &&
                                  widget.whatsAppNumber.toString() !=
                                      "null") {
                                launch(
                                    'https://wa.me/+91${widget.whatsAppNumber}?text=${widget.whatsAppText ?? ""}');
                                // launch('https://wa.me/+917747071882?text=hi hello');
                              }
                            },
                            child: Image.network(
                              widget.privacyImage ?? "",
                              // loadingBuilder: (context, child, loadingProgress) {
                              //     if(loadingProgress==null)
                              // },
                            )),
                      ));

                  // showMessage(context2, 'Tap');

                  return;
                }
              },
              child: Icon(Icons.add),
            );
          } else {
            return Container();
          }
        },
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
      getHome();
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

  void _showCategoryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  for (int i = 0; i < sub_categorylist_string.length; i++) ...[
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              insertLog(context,
                                  deviceId:
                                  ref.read(profileProvider)?.deviceId ?? "",
                                  id: sub_categorylist_string[i].SubCategoryId,
                                  type: InsertLogType.subCategory);
                              setState(() {
                                selected_sub_sub_category = 0;
                                selected_sub_category = int.parse(
                                    sub_categorylist_string[i].SubCategoryId);

                                ref
                                    .read(subSubCategoryProvider.notifier)
                                    .clean();
                                ref
                                    .read(subSubCategoryProvider.notifier)
                                    .lodeCategory(context,
                                    selected_sub_category.toString());
                                category_label = sub_categorylist_string[i]
                                    .SubCategoryName as String;
                              });
                              Future.delayed(Duration(milliseconds: 1), () {
                                getHome();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  '•	${sub_categorylist_string[i].SubCategoryName}',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _showSubSubCategoryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  for (int i = 0; i < sub_sub_categorylist_string.length; i++) ...[
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              print('selected_categoryselected_category${sub_sub_categorylist_string}');
                              setState(() {
                                selected_sub_sub_category = int.parse(sub_sub_categorylist_string[i].SubSubCategoryId);
                                subSubCategoryLabel='${sub_sub_categorylist_string[i].SubSubCategoryName}';
                              });
                              Future.delayed(Duration(milliseconds: 1), () {
                                getHome();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  '•	${sub_sub_categorylist_string[i].SubSubCategoryName}',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCustomDropdown(String label, String selectedValue) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add grey border
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
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
                        child:
                        Text(city.CityName), // Replace with the actual property
                      );
                    },
                  ).toList(),
                  hint: Text(label),
                )),
          ),
        ],
      ),
    );
  }
}

//  ///
void showCustomPopup(
    BuildContext context, image, WhatsappNumber, WhatsappText, Url, AdId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomPopup(
          onClose: () {
            // Call your function here
            print('Function called on close button click');
          },
          image: image,
          WhatsappNumber: WhatsappNumber,
          WhatsappText: WhatsappText,
          Url: Url,
          AdId: AdId);
    },
  );
}

class CustomPopup extends StatelessWidget {
  final Function onClose;
  final String image;
  final String WhatsappNumber;
  final String WhatsappText;
  final String Url;
  final String AdId;
  const CustomPopup(
      {Key? key,
        required this.onClose,
        required this.image,
        required this.WhatsappNumber,
        required this.WhatsappText,
        required this.Url,
        required this.AdId})
      : super(key: key);
  ad_response(ad_id) async {
    var url = Config.insert_ad_response;
    String deviceId = await DeviceHelper.getDeviceId();
    print('deviceId${deviceId}');
    print('ad_id${ad_id}');
    http.Response response = await http.post(Uri.parse(url),
        body: {"user_id": '${deviceId}', "ad_id": '${ad_id}'});

    // logger.i("${url} \n${response.statusCode} \n${jsonDecode(response.body)}");

    print(" respons 5 ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              ad_response(AdId);
              String w_no = WhatsappNumber;
              String w_msg = WhatsappText;
              String w_url = "https://wa.me/+91${w_no}?text=${w_msg}";
              if (Url != '') {
                w_url = Url;
              }

              launchUrl(Uri.parse(w_url));
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20), // Set the border radius
              ),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: Config.Image_Path + 'local_ad/${image}',
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
            ),
          ),
          Positioned(
            top: 1.0,
            right: 1.0,
            child: GestureDetector(
              onTap: () {
                onClose();
                Navigator.of(context).pop();
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

class UpdateAlertDialog extends StatelessWidget {
  final String message;
  final String appStoreUrl;

  UpdateAlertDialog({required this.message, required this.appStoreUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Version Available'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _launchURL(appStoreUrl);
          },
          child: Text('Update Now'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Close loader
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
