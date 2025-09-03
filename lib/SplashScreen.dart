import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:localapp/CategoryScreen.dart';

class SplashScreen extends StatefulWidget {
  ReceivedAction? initialAction;
  SplashScreen({Key? key, this.initialAction}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final FirebaseMessaging _messaging;
  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }


  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 5));

    // Navigate only if there's no active navigation already
    if (Navigator.canPop(context)) return;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CategoryScreen(initialAction: widget.initialAction),
          // builder: (context) => TestScreen(),
        ));
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/splash_screen.gif'),
            ),
          ],
        ),
      ),
    );
  }
}
