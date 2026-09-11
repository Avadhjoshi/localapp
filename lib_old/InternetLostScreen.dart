import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetLostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white, // Change app bar color to white
        elevation: 0.0, // Remove the bottom border

        iconTheme: IconThemeData(color: Colors.black), //
        // Change icon color to black
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.black), // Change text color to black
        // ),

        centerTitle: true,
// Back arrow
        actions: [
          // Add any additional actions here
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/LostInternet.gif'), // Add your image here
          ],
        ),
      ),
    );
  }
}