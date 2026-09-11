import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetLostScreen extends StatefulWidget {
  const InternetLostScreen({Key? key}) : super(key: key);

  @override
  State<InternetLostScreen> createState() => _InternetLostScreenState();
}

class _InternetLostScreenState extends State<InternetLostScreen> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription =
        Connectivity().onConnectivityChanged.listen((result) {
          if (result != ConnectivityResult.none) {
            Navigator.of(context).pop(); // go back automatically
          }
        });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(
          'assets/images/lostinternet.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
