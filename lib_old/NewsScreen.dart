import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:localapp/CityScreen.dart';

import 'BuySellScreen.dart';
import 'HomeScreen.dart';
import 'JobScreen.dart';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int selectedIdx = 3;
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
       // _showCustomDialog();
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
      if(index==4)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CityScreen()));

      }
      if (index == selectedIdx) {
        // If the same item is tapped again, clear the selection
        selectedIdx = 0;
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
  int selectedIdx_2 = -1;

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
    return  Scaffold(

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Image.asset('assets/images/news_image1.png',
                        width: double.infinity,
                        fit: BoxFit.cover,),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset('assets/images/news_image2.png'), // Replace with your image path
                          ),
                          Expanded(
                            child: Image.asset('assets/images/news_image3.png'), // Replace with your image path
                          ),
                          Expanded(
                            child: Image.asset('assets/images/news_image3.png'), // Replace with your image path
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),

                      Container(
                        padding: const EdgeInsets.only(left:10),
                        child:  Text(
                          '32 साल बाद, PMC ने मुंडवा - केशवनगर रोड को सिर्फ 24 घंटों में व्यापक किया।',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left:10),
                      child:  Text(
                        '32 साल बाद, पीएमसी ने त्वरित रूप से मुंडवा-केशवनगर जंक्शन पर सड़क को व्यापक किया।\nउन्होंने बाधाएँ हटा दी।',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Colors.black, // Set the background color to black
                        ),
                        child:
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child:
                          Text(
                          'Message on Facebook',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.white,
                          ),
                        ),
                        ),
                      ),


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
                                '9 hours ago ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),





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
                      Image.asset('assets/images/news_banner.png',
                        width: double.infinity,
                        fit: BoxFit.cover,),


                    ],
                  ),
                ),




              ],
            ),
          )
      );
  }

}