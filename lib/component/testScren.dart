import 'package:flutter/material.dart';
import 'package:localapp/HomeScreen.dart';
import 'package:localapp/MoreScreen.dart';
import 'package:localapp/MyPostScreen.dart';

import '../CityScreen.dart';



class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  
  final pageController = PageController();
  int _cp = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //body
      body: PageView(
        onPageChanged: (n){
          n=_cp;
        },
        controller: pageController,
        children: [
          // HomeScreen("1","2"),
          CityScreen(),
          MyPostScreen(false),
          MoreScreen()
        ],
      ),
      
      //bottom Navigation bar
      bottomNavigationBar: Card(
        child: BottomNavigationBar(
          currentIndex: _cp,
            items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "1"),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit),label: "2"),
          BottomNavigationBarItem(icon: Icon(Icons.catching_pokemon),label: "3"),
          BottomNavigationBarItem(icon: Icon(Icons.more),label: "4"),
        ]),
      ),
      
      
    );
  }
}
