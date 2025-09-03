import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}