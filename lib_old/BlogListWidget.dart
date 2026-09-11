import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localapp/BlogDetail.dart';
import 'package:localapp/constants/postPrivetType.dart';
import 'package:localapp/constants/style%20configuration.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'constants/Config.dart';
import 'models/BlogList.dart';
import 'providers/profieleDataProvider.dart';

class BlogListWidget extends StatefulWidget {
  @override
  _BlogListWidgetState createState() => _BlogListWidgetState();
  final Blog_list blog;
  final String selected_category;
  final String selected_sub_category;
  final String privecyType;
  final String? privacyImage;
  final String? whatsAppNumber;
  final String? whatsAppText;

  const BlogListWidget(
      this.blog, this.selected_category, this.selected_sub_category,
      {this.whatsAppText,
      this.whatsAppNumber,
      required this.privecyType,
      this.privacyImage});
}

class _BlogListWidgetState extends State<BlogListWidget> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = const Duration(seconds: 2);
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',
    flags:
        const YoutubePlayerFlags(autoPlay: false, controlsVisibleAtStart: true),
  );
  int currentPage = 1;
  bool isLoading = false;
  String videoId = '';
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
    if (widget.blog.videoLink != '') {
      videoId = YoutubePlayer.convertUrlToId("${widget.blog.videoLink}")!;
      _controller = YoutubePlayerController(
        initialVideoId: '${videoId}',
        flags: const YoutubePlayerFlags(
            autoPlay: false, controlsVisibleAtStart: true),
      );
    }
    // Your widget implementation for displaying a single blog item
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return GestureDetector(
          onLongPress: () {
            if (kDebugMode) {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text(blogListToJson(widget.blog)),
                      ));
            }
          },
          onTap: () {
            var profile = ref.read(profileProvider);

            //Privet Dialog
            if (widget.privecyType == CategoryPrivacyType.private &&
                profile!.groupAccess
                        .toString()
                        .split(",")
                        .contains(widget.selected_category) ==
                    false) {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: GestureDetector(
                            onTap: () {
                              logger.t(
                                  "${widget.whatsAppNumber} (${widget.whatsAppText})");
                              if (widget.whatsAppNumber.toString().isNotEmpty &&
                                  widget.whatsAppNumber.toString() != "null") {
                                launch(
                                    'https://wa.me/+91${widget.whatsAppNumber}?text=${widget.whatsAppText ?? ""}');
                                // launch('https://wa.me/+917747071882?text=hi hello');
                              }
                            },
                            child: Image.network(widget.privacyImage ?? "")),
                      ));
            } else {
              
              
              Logger().i("Open Post ${widget.blog.blogPostId}\n${widget.selected_category}\n${widget.selected_sub_category}");
              
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailScreen(
                    widget.blog.blogPostId ?? "1",
                    widget.selected_category,
                    widget.selected_sub_category,
                    false,
                  ),
                ),
              );
            }
          },
          child: Card(
            // color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (kDebugMode) Text("${widget.selected_category}"),

                  //
                  if (widget.blog.videoLink != '') ...[
                    Stack(
                      children: [
                        Image.network(
                          'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 72.0,
                        ),
                      ],
                    ),

                    /* YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),*/
                    // Add your video rendering here...
                  ] else ...[
                    if (widget.blog.postDisplayPhoto != '') ...[
                      showShimmer
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 380,
                                color: Colors.white,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  '${Config.Image_Path}blog/${widget.blog.postDisplayPhoto}',
                              placeholder: (context, url) => Image.asset(
                                "assets/images/loader.gif",
                                width: 80,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/loader.gif",
                                width: 80,
                                height: 80,
                              ),
                            ),
                    ],
                  ],
                  showShimmer
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      : Container(
                    margin: EdgeInsets.only(top: 10),
                    color: kDebugMode? Colors.red.withOpacity(.3):null,
                        child: Html(
                            data: widget.blog.heading,
                            style: {
                              "body": Style(
                                padding: EdgeInsets.zero,
                                margin: const EdgeInsets.all(0),
                              ),
                            },
                          ),
                      ),

                  if (widget.blog.postByName != "")
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      color: kDebugMode? Colors.red:null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 22,
                            margin: const EdgeInsets.only(left: 0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.blog.postByName.toString().trim()[0],
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.blog.postByName}',
                            style: StyleConfiguration.areaTextStyle,
                          ),
                          // Add spacing between the icon and text
                        ],
                      ),
                    ),


                  if (widget.blog.area != null &&
                      widget.blog.area.toString().isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      color: kDebugMode? Colors.red.withOpacity(.5):null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 24,
                              height: 22,
                              margin: const EdgeInsets.only(left: 0, bottom: 2),
                              decoration: BoxDecoration(
                                // color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Icon(Icons.location_pin))),
                          Expanded(
                            child: Text(
                              '${widget.blog.area}',
                              overflow: TextOverflow.ellipsis,
                              style: StyleConfiguration.areaTextStyle,
                            ),
                          )
                        ],
                      ),
                    ),

                  showShimmer
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity / 2,
                                height: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                widget.blog.subCategoryName ?? "",
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                  // Row(children: [
                  //   const Icon(Icons.visibility),
                  //   Text('  ${widget.blog.totalClicks??"0"}')
                  // ],),

                  showShimmer
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity / 3,
                                height: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 16.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                widget.blog.timeAgo ?? '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              //
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),

                  // Row(
                  //   children: [
                  //     Text("Expire on: ${widget.blog.endDate?.day??""}, ${month[widget.blog.endDate?.month]??""} ${widget.blog.endDate?.year??""}",
                  //       style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
