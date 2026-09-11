import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../InternetLostScreen.dart';

class InternetGuard extends StatefulWidget {
  final Widget child;
  const InternetGuard({super.key, required this.child});

  @override
  State<InternetGuard> createState() => _InternetGuardState();
}

class _InternetGuardState extends State<InternetGuard> {
  late StreamSubscription _subscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitial();
    _subscription =
        Connectivity().onConnectivityChanged.listen((result) {
          setState(() {
            _hasInternet = result != ConnectivityResult.none;
          });
        });
  }

  Future<void> _checkInitial() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = result != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hasInternet ? widget.child : const InternetLostScreen();
  }
}
