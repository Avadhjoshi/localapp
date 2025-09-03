import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localapp/MyPostScreen.dart';
import 'package:localapp/StorPref.dart';
import 'package:localapp/component/customTextFeild.dart';
import 'package:localapp/providers/profieleDataProvider.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddPost1Screen.dart';
import 'CategoryScreen.dart';
import 'CityScreen.dart';
import 'MoreScreen.dart';
import 'MultiImagePicker.dart';
import 'MyBlogListWidget.dart';
import 'constants/Config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/gestures.dart'; // Import gesture recognizer
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'constants/prefs_file.dart';
import 'models/BlogList.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPost2Screen extends ConsumerStatefulWidget {
  String CategoryId, Desc;
  List<File> images = [];
  String image_1;
  AddPost2Screen(this.CategoryId, this.Desc, this.images, this.image_1);
  @override
  _AddPost2ScreenState createState() => _AddPost2ScreenState();
}

class CustomErrorDialog extends StatefulWidget {
  String message;
  CustomErrorDialog(this.message);

  @override
  _CustomErrorDialogState createState() => _CustomErrorDialogState();
}

class _CustomErrorDialogState extends State<CustomErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/error_icon.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.message}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/green_right.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Post Uploaded Successfully',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'It will be visible on Local App after approval from Admin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //   MaterialPageRoute(
                    //       builder: (context) => MyPostScreen(true)),
                    //   (route) => false,
                    // );
                  },
                  child: const Text('Go To My Post'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/green_right.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Post upload in progress…',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    /* Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) =>MyPostScreen(true)),
                          (route) => false,
                    );*/
                  },
                  child: const Text('Okay'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddPost2ScreenState extends ConsumerState<AddPost2Screen> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = const Duration(seconds: 2);
  String DescriptionPlaceholder = '';
  int selectedIdx = 0;
  String status = '';
  int selected_category = 1;
  int selected_sub_category = 1;
  String image_1 = 'Profile Image';
  String _path_1 = "";
  TextEditingController name_con = new TextEditingController();
  TextEditingController _textEditingController = new TextEditingController();
  Prefs prefs = new Prefs();
  String app_title = 'Contact Info';
  bool form_visible = true;
  bool my_post_visible = false;
  bool load_more = true;
  int blog_page = 0;
  int total_page = 0;
  String CustomerCare = '';

  late String selectedOption = '';
  final navigatorKey = GlobalKey<NavigatorState>();
  ScrollController _scrollController = ScrollController();

  bool isVisibleDiv = false;

  List blog_data = [];
  List<Blog_list> blog_string = [];
  List<Blog_list> blog_string_list = [];

  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  int _currentIndexBottom = 2;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () {
      get_name();
      getApi();
      getSetupApi();
    });
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });
    getArea();

    super.initState();
  }

  getSetupApi() async {
    var url = Config.get_setup;

    http.Response response = await http.post(Uri.parse(url), body: {});

    Map<String, dynamic> data = json.decode(response.body);
    logger.i("$url\n ${response.statusCode} \n${data}");
    print('data${data}');
    status = data["success"];
    print('setup${data["data"]}');

    if (status == "0") {
      setState(() {
        CustomerCare = data["data"]["setup"][0]['Cust_Care_Num'] == null
            ? ''
            : data["data"]["setup"][0]['Cust_Care_Num'];
      });
    } else {}
  }

  Future<void> getApi() async {
    print('getapi called');
    try {
      // showLoaderDialog(context);
      blog_data = [];
      blog_string = [];

      String? deviceId = await PlatformDeviceId.getDeviceId;

      var url = Config.get_my_post;
      blog_page = 0;

      http.Response response = await http.post(Uri.parse(url), body: {
        'blog_page': '${blog_page}',
        'PostById': '$deviceId',
        'user_id': '$deviceId'
      }).timeout(const Duration(seconds: 20));

      // Set timeout to 30 seconds
      Map<String, dynamic> data = json.decode(response.body);
      logger.i("$url\n ${response.statusCode} \n${data}");
      status = data["success"];
      print('statusstatus$status');
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        if (status == "0") {
          setState(() {
            blog_data = data['data']['blog'] as List;
            blog_string = blog_data
                .map<Blog_list>((json) => Blog_list.fromJson(json))
                .toList();
            total_page = data['data']['total_page'] == null
                ? 0
                : data['data']['total_page'];
          });
        } else {}
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Request failed with error: $e');
      // Show retry popup
      Navigator.of(context).pop();

      //RetryPopup();
    }
  }

  get_name() async {
    String recent_name = await prefs.getpost_name();
    String recent_selected = await prefs.getpost_desc();
    String recent_contact = await prefs.getpost_contact();
    setState(() async {
      var user = ref.read(profileProvider);
      if (user != null) {
        name_con.text = user.name ?? "unknown";
      } else {
        ref.read(profileProvider.notifier).getUser(context);
        var _user = ref.read(profileProvider);
        name_con.text = user?.name ?? "unknown";
      }

      // if(recent_name!='')
      // {
      //   name_con.text='${recent_name}';
      // }
      if (recent_selected != '') {
        selectedOption = recent_selected;
      }
      if (recent_contact != '') {
        _textEditingController.text =
            ref.read(profileProvider)?.mobileNumber1 ?? "";
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  void onItemClicked(int index, String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category = int.parse(subcat_id);
    });
    // GetApiData();
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(),
      ),
    );
  }

  submit_api() async {
    //
    setState(() {
      isVisibleDiv = true;
      form_visible = false;
      my_post_visible = true;
      app_title = 'My Post';
      prefs.setpost_uploading('Yes');
    });

    //
    if (addressController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => CustomErrorDialog(
            "Fill all the required information first and then submit.submi"),
      );
      return;
    }

    //
    showLoaderDialog(context);
    String? deviceId = await PlatformDeviceId.getDeviceId;


    await Future.delayed(Duration(milliseconds: 1000), () {
      //
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog();
        },
      );
    });

    var url_update_upload = Config.update_upload;
    blog_page = 0;

    print('deviceId${deviceId}');

    http.Response response_upload =
        await http.post(Uri.parse(url_update_upload), body: {
      'PostById': '$deviceId',
    });

    Logger().e(
        "responce frome post api1 ${response_upload.statusCode} \n ${response_upload.body}");

// Set timeout to 30 seconds

    var uri = Uri.parse(Config.post_upload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = '${deviceId}';
    request.fields['description'] = widget.Desc;
    request.fields['name'] = name_con.text;
    request.fields['selectedOption'] = '${selectedOption}';
    request.fields['category_id'] = '${widget.CategoryId}';
    request.fields['ContactDetail'] = '${_textEditingController.text}';
    request.fields['PostById'] = '${deviceId}';
    request.fields['Area'] = '${addressController.text.trim()}';

    await LocalDb().savePrevArea(addressController.text.trim());

    if (widget.image_1 != '') {
      request.files
          .add(await http.MultipartFile.fromPath('image_1', widget.image_1));
    }

    for (int i = 0; i < widget.images.length; i++) {
      File imageFile = File(widget.images[i].path);
      if (imageFile.existsSync()) {
        http.MultipartFile imageMultipartFile =
            await http.MultipartFile.fromPath(
          'image_${i + 2}',
          imageFile.path,
          filename: 'image_$i.jpg',
        );
        request.files.add(imageMultipartFile);
      }
    }

    http.Response response =
        await http.Response.fromStream(await request.send());

    Navigator.pop(context);

    Logger().e(
        "responce frome post api ${response.statusCode} \n ${response.body}");

    Map<String, dynamic> datauser = json.decode(response.body);
    logger.i("$uri\n ${response.statusCode} \n${datauser}");
    setState(() {
      if (datauser['success'] == '0') {
        prefs.setpost_name(name_con.text);
        prefs.setpost_desc(selectedOption);
        prefs.setpost_contact(_textEditingController.text);
        prefs.setpost_uploading('No');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomSuccessDialog();
          },
        );
        Fluttertoast.showToast(
            msg: datauser['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            fontSize: 15.0);
        setState(() {
          isVisibleDiv = false;
        });
        Future.delayed(const Duration(milliseconds: 1), () {
          getApi();
        });
      } else {
        Fluttertoast.showToast(
            msg: datauser['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 15.0);
      }
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

  TextEditingController addressController = TextEditingController();

  Future<void> getArea() async {
    String? db = await LocalDb().getPrevArea();
    logger.t(db);
    addressController.text = db ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Set this to true

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Change app bar color to white
        elevation: 0.0, // Remove the bottom border
        leading: IconButton(
          // icon: Icon(Icons.arrow_back),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (my_post_visible == true) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CategoryScreen()),
                (route) => false,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        iconTheme: const IconThemeData(
            color: Colors.black), // Change icon color to black
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.black), // Change text color to black
        // ),

        centerTitle: true,
// Back arrow
        title: Row(
          children: [
            // Add spacing between the image and text
            Text('${app_title}',
                style: const TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
        actions: [
          if (form_visible == true) ...[
            GestureDetector(
              onTap: () {
                print('selectedOption${selectedOption}');
                print('_textEditingController${_textEditingController.text}');

                if (addressController.text.trim().isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                  return;
                }

                if (name_con.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == 'On WhatsApp' &&
                    _textEditingController.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == 'On Call' &&
                    _textEditingController.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == 'On Email' &&
                    _textEditingController.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == 'On Facebook Messenger' &&
                    _textEditingController.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Fill all the required information first and then submit.");
                    },
                  );
                } else if (selectedOption == 'On WhatsApp' &&
                    _textEditingController.text.length != 10) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Please Enter Valid WhatsApp Number.");
                    },
                  );
                } else if (selectedOption == 'On Call' &&
                    _textEditingController.text.length != 10) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Please Enter Valid Mobile Number.");
                    },
                  );
                } else if (selectedOption == 'On Email' &&
                    !isValidEmail(_textEditingController.text)) {
                  print('on email');
                  print('isvlalid${isValidEmail(_textEditingController.text)}');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomErrorDialog(
                          "Please Enter Valid Email Address.");
                    },
                  );
                } else {
                  //submit_api();
                  submit_api().then((_) {
                    // Handle completion
                    // This part of the code will execute even if the user changes the screen
                  }).catchError((error) {
                    // Handle errors
                  });
                }
              },
              child: SizedBox(
                height: 20, // Adjust height as needed
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Adjust font size as needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),

      body: WillPopScope(
          onWillPop: () async {
            // Intercept back button press
            // Navigate to HomeScreen and prevent going back to this screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => CategoryScreen()),
              (route) => false,
            );

            // Return false to prevent the default back button behavior
            return false;
          },
          child: RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Visibility(
                    visible: form_visible,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Distribute space evenly between images
                            children: const [
                              Text('Your Name or Business Name',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Distribute space evenly between images
                            children: const [
                              Text('This will be displayed against your post.',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),

                        //name
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: kDebugMode ? Colors.grey.shade200 : null,
                          child: CustomTextField(
                              enabled: false,
                              controller: name_con,
                              hintText: "Mention your name here"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //Area Fields
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              const Text('Enter Your Area/Location',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                              const SizedBox(
                                height: 5,
                              ),

                              //
                              const Text(
                                  "This will be displayed against your post.",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),

                              CustomTextField(
                                  controller: addressController,
                                  hintText: "Area/Location"),
                            ],
                          ),
                        ),

                        //
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Distribute space evenly between images
                            children: const [
                              Text('How do you want people to contact you?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CheckboxListTile(
                              activeColor:
                                  Colors.black, // Set the active color to black

                              title: const Text('On WhatsApp'),
                              value: selectedOption == 'On WhatsApp',
                              onChanged: (value) {
                                setState(() {
                                  selectedOption =
                                      (value! ? 'On WhatsApp' : null)!;
                                  if (value) {
                                    FocusScope.of(context)
                                        .unfocus(); // Close keyboard
                                    _textEditingController.text = '';
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              title: const Text('On Call'),
                              activeColor:
                                  Colors.black, // Set the active color to black

                              value: selectedOption == 'On Call',
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = (value! ? 'On Call' : null)!;
                                  if (value) {
                                    FocusScope.of(context)
                                        .unfocus(); // Close keyboard
                                    _textEditingController.text = '';
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              title: const Text('On Email'),
                              activeColor:
                                  Colors.black, // Set the active color to black

                              value: selectedOption == 'On Email',
                              onChanged: (value) {
                                setState(() {
                                  selectedOption =
                                      (value! ? 'On Email' : null)!;
                                  if (value) {
                                    FocusScope.of(context)
                                        .unfocus(); // Close keyboard
                                    _textEditingController.text = '';
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor:
                                  Colors.black, // Set the active color to black

                              title: const Text('On Facebook Messenger'),
                              value: selectedOption == 'On Facebook Messenger',
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = (value!
                                      ? 'On Facebook Messenger'
                                      : null)!;
                                  if (value) {
                                    FocusScope.of(context).unfocus();
                                    _textEditingController.text = '';
                                    // Close keyboard
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            if (selectedOption != null &&
                                selectedOption.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      selectedOption == 'On WhatsApp'
                                          ? 'Enter 10 digit WhatsApp number.'
                                          : selectedOption == 'On Call'
                                              ? 'Enter 10 digit Calling number.'
                                              : selectedOption == 'On Email'
                                                  ? 'Enter Email Address.'
                                                  : 'Enter facebook user name.',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // CustomTextField(controller: _textEditingController, hintText: selectedOption ==
                                    //     'On WhatsApp'
                                    //     ? 'WhatsApp number'
                                    //     : selectedOption == 'On Call'
                                    //     ? 'Calling number'
                                    //     : selectedOption == 'On Email'
                                    //     ? 'Email Address'
                                    //     : 'Facebook user name'),

                                    TextField(
                                      controller: _textEditingController,
                                      maxLength: selectedOption == 'On WhatsApp'
                                          ? 10
                                          : selectedOption == 'On Call'
                                              ? 10
                                              : 500,
                                      keyboardType: selectedOption == 'On Email'
                                          ? TextInputType.emailAddress
                                          : selectedOption ==
                                                  'On Facebook Messenger'
                                              ? TextInputType.text
                                              : TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                        counterText: "",
                                        hintText: selectedOption ==
                                                'On WhatsApp'
                                            ? 'WhatsApp number'
                                            : selectedOption == 'On Call'
                                                ? 'Calling number'
                                                : selectedOption == 'On Email'
                                                    ? 'Email Address'
                                                    : 'Facebook user name',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                    if (selectedOption ==
                                        'On Facebook Messenger')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text:
                                                'Having trouble finding your Facebook user id, let us know we will help you. ',
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    'click here to contact us.',
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = _launchURL,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    // const SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: my_post_visible,
                    child: Container(
                      height: 700,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Visibility(
                                  visible: isVisibleDiv,
                                  child: Card(
                                    margin: const EdgeInsets.all(
                                        15.0), // Margin of 10 pixels around the container
                                    child: Image.asset(
                                      'assets/images/PostUploadInProgress.gif',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 80, // Image asset path
                                    ),
                                  )),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: blog_string.length +
                                    1, // +1 for the loading indicator
                                itemBuilder: (context, index) {
                                  if (index == blog_string.length) {
                                    if (load_more == true)
                                      return _buildLoadingIndicator();
                                  } else {
                                    return MyBlogListWidget(
                                        blog_string[index],
                                        '${selected_category}',
                                        '${selected_sub_category}');
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
                    ),
                  ),
                ],
              )))),
      bottomNavigationBar: my_post_visible == true
          ? BottomNavigationBar(
              currentIndex: _currentIndexBottom,
              onTap: (int index) {
                setState(() {
                  _currentIndexBottom = index;
                  if (_currentIndexBottom == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()));
                  }
                  if (_currentIndexBottom == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CityScreen()));
                  }

                  if (_currentIndexBottom == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyPostScreen(false)));
                  }
                  if (_currentIndexBottom == 3) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MoreScreen()));
                  }
                });
              },
              selectedItemColor:
                  Colors.blue, // Set the selected item color to white
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
            )
          : null,
    );
  }

  void _launchURL() async {
    String facebookMessengerUrl =
        "https://wa.me/+91${CustomerCare}?text=Hello! Local App. I want help to find out my facebook user id."; // URL for Facebook Messenger

    if (selectedOption == 'On Facebook Messenger') {
      facebookMessengerUrl += _textEditingController.text;
      if (await canLaunch(facebookMessengerUrl)) {
        await launch(facebookMessengerUrl);
      } else {
        throw 'Could not launch $facebookMessengerUrl';
      }
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future _refreshData() async {}

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
