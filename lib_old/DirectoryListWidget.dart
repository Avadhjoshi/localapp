
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'directoryDetail.dart';

import 'package:url_launcher/url_launcher.dart';
import 'constants/Config.dart';
import 'models/directoryList.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

class DirectoryListWidget extends StatefulWidget {
  @override
  _DirectoryListWidgetState createState() => _DirectoryListWidgetState();
  final Directory_list directory;
  String selected_category;
  String selected_sub_category;
  bool MyDirectory;

  DirectoryListWidget(this.directory,this.selected_category,this.selected_sub_category,this.MyDirectory);

}


class _DirectoryListWidgetState extends State<DirectoryListWidget> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = Duration(seconds: 2);
  late YoutubePlayerController _controller=YoutubePlayerController(
    initialVideoId: '',
    flags: YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true
    ),
  );
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Start a timer to hide the shimmer after 2 seconds
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // Your widget implementation for displaying a single directory item
    return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DirectoryDetailScreen(
              widget.directory.ContactId,
              '${widget.selected_category}',
              '${widget.selected_sub_category}',
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(

                children: [

                  showShimmer ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width:60,
                          height:60,
                          color: Colors.white,
                        ),
                  ): CachedNetworkImage(
                    imageUrl:Config.Image_Path+'directory_contact/'+widget.directory.DisplayPhoto,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/images/loader.gif",
                      width: 50,
                      height: 50,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/loader.gif",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(width: 5,),
                   Container(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showShimmer
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 150,
                                height: 20,
                                color: Colors.white,
                              ),
                        ):Container(
                          width: 200,
                          child:  Text(
                            '${widget.directory.FullName}',
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ),






                        SizedBox(height: 5),
                        showShimmer
                            ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 20,
                            color: Colors.white,
                          ),
                        ):
                        Container(
                          width: 200,
                          child: Text(
                          '${widget.directory.SubCategoryName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue
                          ),
                        ), ),
                        SizedBox(height: 5),

                        showShimmer
                            ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 20,
                            color: Colors.white,
                          ),
                        ):  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on, // Map pin icon
                              color: Colors.black, // Optional: Set the color of the icon
                              size: 15, // Optional: Set the size of the icon
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 200,
                              child:  Text(
                                '${widget.directory.ServiceRange}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Add spacing between the icon and text
                          ],
                        ),
                        SizedBox(height: 5),


                      ],
                    ),
                  ),
                  Spacer(),
                  if(widget.directory.IDVerified=='Y')...[
                    SizedBox(width: 55,
                      child:
                      Image.asset(
                        'assets/images/IDVerifiedLabel.png',
                        height: 60,
                        width: 55,
                      ),
                    ),
                  ],

                ],
              ),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [


                  SizedBox(
                    height: 60,
                    width: 60,
                  ),



                  Container(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showShimmer
                            ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 150,
                            height: 20,
                            color: Colors.white,
                          ),
                        ):
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Container(
                                width: 260, // Set the width as needed
                                child:
                                Html(
                                  data:'${widget.directory.ShortDesc}',
                                  onLinkTap: (url, _, __, ___) async {
                                    if (await canLaunch(url!)) {
                                      await launch(
                                        url,
                                      );
                                    }
                                  },

                                )
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ],
              ),

              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){

                      launchUrl("tel://${widget.directory.CallingNumber}");
                    },child:

                  Row(
                    children: [


                      Image.asset(
                        'assets/images/call.png',
                        height: 25,
                        width: 25,
                      ),  SizedBox(width: 2),
                      Text('Call'),
                    ],
                  ),
                  ),
                  GestureDetector(
                    onTap: (){

                      launchUrl("https://wa.me/+91${widget.directory.WhatsappNumber}");
                    },child:

                  Row(
                    children: [
                      Image.asset(
                        'assets/images/whatsapp.png',
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 2),
                      Text('WhatsApp'),
                    ],
                  ),
                  ),

                  GestureDetector(
                    onTap: (){

                      String msg="This contact is shared from Local App.\n*Name:* ${widget.directory.FullName}\n*Contact Number:* ${widget.directory.CallingNumber}\n ${widget.directory.CategoryName} - ${widget.directory.SubCategoryName}";
                      Share.share('${msg}',
                          subject: 'Local App');


                    },child:

                  Row(
                    children: [
                      Image.asset(
                        'assets/images/share.png',
                        height: 25,
                        width: 25,
                      ), SizedBox(width: 2),
                      Text('Share'),
                    ],
                  ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
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
