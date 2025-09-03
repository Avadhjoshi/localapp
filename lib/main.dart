import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/SplashScreen.dart';
import 'package:localapp/constants/prefs_file.dart';
import 'package:localapp/noticication%20function.dart';
import 'package:localapp/providers/profieleDataProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'BlogDetail.dart';
import 'CityDetailScreen.dart';
import 'HomeScreen.dart';
import 'MyPostScreen.dart';
import 'constants/Config.dart';
import 'constants/postPrivetType.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //
    AwesomeNotifications().initialize(
      debug: true,
      // Your app icon
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );
  ReceivedAction? initialAction =
      await AwesomeNotifications().getInitialNotificationAction();
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: tapHandler,
  );

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // AwesomeNotifications().requestPermissionToSendNotifications();
  }
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      showbackgroundNotification(message);
    }
  });
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onBackgroundMessage(showbackgroundNotification);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    logger.f("onMessage: ${message.data}");

    // await showbackgroundNotification(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    logger.f("onMessage: ${message.data}");
    await showbackgroundNotification(message);
  });

  //
  // FirebaseMessaging.onMessage.listen(onMessageHandler);

  //
  FirebaseMessaging.instance.getToken().then((token) {
    print("tokenxssn: $token");
  });
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  runApp(UncontrolledProviderScope(
      container: ProviderContainer(),
      child: main_app(
        initialAction: initialAction,
      )));
}

@pragma('vm:entry-point')
Future<void> showbackgroundNotification(RemoteMessage message) async {
  logger.f("onMessage: ${message.data}");

  // if (message.data.isNotEmpty) {
  //   final blogId = message.data['blog_id'];
  //   if (blogId != null && blogId.isNotEmpty) {
  //     if (navigatorKey.currentContext != null) {
  //       Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(
  //           builder: (context) => BlogDetailScreen(
  //             blogId,
  //             'Notification',
  //             '', // Pass other parameters as needed
  //             false,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }
  String? imageUrl = message.data['image_url'];

  String? bigPicturePath;
  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/notification_image.jpg';
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      bigPicturePath = filePath;
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
  //convert message.data to Map<String, String?>? type from Map<String, dynamic>
  Map<String, String?>? data = message.data.map((key, value) {
    return MapEntry(key, value as String?);
  });
  logger.f("onMessage: ${data}");

// Handle the creation of the notification UI
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(message.data['NotificationId']),
      channelKey: 'basic_channel',
      title: message.data['title'],
      body: message.data['body'],
      payload: data,
      bigPicture: bigPicturePath != null ? 'file://$bigPicturePath' : null,
      notificationLayout: bigPicturePath != null
          ? NotificationLayout.BigPicture
          : NotificationLayout.Default,
    ),
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class main_app extends ConsumerStatefulWidget {
  ReceivedAction? initialAction;
  main_app({Key? key, required this.initialAction}) : super(key: key);

  @override
  _main_appState createState() => _main_appState();
}

class _main_appState extends ConsumerState<main_app> {
  Prefs prefs = new Prefs();

  String? version = '';
  String? storeVersion = '';
  String? storeUrl = '';
  String? packageName = '';

  @override
  void initState() {
    getToken();
    ref.read(profileProvider.notifier).updateLocation(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleInitialAction();
    });
    //_initializeNotifications(); // Ensure this is called during startup
    // if (widget.initialAction != null &&
    //     widget.initialAction!.payload?['blog_id'] != null) {
    // Future.delayed(Duration(seconds: 0), () {

    // });
    // }
    super.initState();
  }
  void handleInitialAction() {
    final action = widget.initialAction;

    if (action == null || action.payload == null) return;

    final payload = action.payload!;
    String? blogId = payload['blog_id'];
    String? typeId = payload['type_id'];

    if (navigatorKey.currentContext == null) return;

    if (typeId == 'Category' && blogId != null && blogId.isNotEmpty) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen("", "", blogId, CategoryPrivacyType.public),
        ),
      );
    } else if (typeId == 'My Post') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => MyPostScreen(false)),
      );
    } else if (typeId == 'Contact') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => CityDetailScreen('3')),
      );
    } else if (blogId != null && blogId.isNotEmpty) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => BlogDetailScreen(blogId, '', '', false),
        ),
      );
    }
  }

  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print('fcm_token${token}');
    // prefs.set_fcm_token(token);

    String user_id = await prefs.ismember_id();
    print('token_home${token}');
    String? deviceId = await PlatformDeviceId.getDeviceId;

    print('deviceId${deviceId}');

    var url = Config.get_home;
    http.Response response = await http
        .post(Uri.parse(url), body: {'user_id': '${deviceId}', "token": token});

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("New FCM Token: $newToken");
      print('deviceId${deviceId}');

      var url = Config.get_home;
      http.Response response = await http.post(Uri.parse(url),
          body: {'user_id': '${deviceId}', "token": newToken});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Local App',
        navigatorKey: navigatorKey, // Set the navigator key
        theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: InputDecorationTheme(
                helperStyle: TextStyle(color: Colors.black))),
        home: SplashScreen(
          initialAction: widget.initialAction,
        ));
  }
}
