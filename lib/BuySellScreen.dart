import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'JobScreen.dart';
import 'NewsScreen.dart';


class BuySellScreen extends StatefulWidget {
  @override
  _BuySellScreenState createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  int selectedIdx = 2;
  List<String> items = [
    "News",
    "Jobs",
    "Buy Sell Rent",
    "Pune Clubs",
    "Offers"
  ];

  void selectItem(int index) {
    setState(() {
      if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));

      }
      if(index==1)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  JobScreen()));

      }
      if(index==2)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  BuySellScreen()));

      }
      if(index==3)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewsScreen()));

      }
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = 2;
      } else {
        selectedIdx = index;
      }
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
  int selectedIdx_2 = 2;

  void onItemClicked(int index) {
    setState(() {
      selectedIdx_2 = index;
    });
  }

  int _currentIndex = 0; // Track the current page index

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          backgroundColor: Colors.white,
          appBar:AppBar(
            backgroundColor: Colors.white, // Change app bar color to white
            elevation: 0.0, // Remove the bottom border

            iconTheme: IconThemeData(color: Colors.black), // Change icon color to black
            // textTheme: TextTheme(
            //   headline6: TextStyle(color: Colors.black), // Change text color to black
            // ),
            // Back arrow
            title:   SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (index) {
                  bool isSelected = index == selectedIdx;
                  return GestureDetector(
                    onTap: () => selectItem(index),
                    child: Container(
                      width: 90.0,
                      height: 30.0,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        // Change container color to transparent
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: Center(
                        child: Text(
                          items[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            // Change text color to white
                            fontSize: 12.0, // Set font size to a smaller value
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            actions: [
              // Add any additional actions here
            ],
          ),

          body:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(items_2.length, (index) {
                      bool isSelected = index == selectedIdx_2;
                      return GestureDetector(
                          onTap: () => onItemClicked(index),
                          child:isSelected
                              ? Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              items_2[index],
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blue, // Color of the underline
                                  width: 2.0, // Fixed underline thickness when isSelected is true
                                ),
                              ),
                            ),
                          )
                              : Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              items_2[index],
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )


                      );
                    }),
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset('assets/images/buy_sell.png',
                        width: double.infinity,
                        fit: BoxFit.cover,),

                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Image.asset('assets/images/buy_sell_image1.png',
                        width: double.infinity,
                        fit: BoxFit.cover,),
                      SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.only(left:10),
                        child:  Text(
                          'Double Bed for Sale @ 13000 Only - Lohegaon',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child:    Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 16.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              '9 hours ago',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),





              ],
            ),
          )
      );
  }

}