import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localapp/MyPostScreen.dart';
import 'package:localapp/constants/style%20configuration.dart';
import 'package:localapp/models/Category.dart';
import 'package:localapp/models/SubCategory.dart';
import 'package:logger/logger.dart';

import 'constants/DeviceHelper.dart';import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'VideoPlayerScreen.dart';
import 'constants/Config.dart';
import 'constants/DeviceHelper.dart';
import 'features/home/widgets/group_preview_tile.dart';
import 'features/home/widgets/group_tile_blog.dart';
import 'image_viewer.dart';
import 'models/BlogDetailList.dart';
import 'models/LocalAd.dart';

class BlogDetailScreen extends StatefulWidget {
  String BlogPostId;
  String PostCategory;
  String PostSubCategory;
  bool FromMyPost;
  BlogDetailScreen(this.BlogPostId, this.PostCategory, this.PostSubCategory,
      this.FromMyPost);

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool showShimmer = true; // Track whether to show shimmer or data
  final Duration shimmerDuration = const Duration(milliseconds: 600);

  int selectedIdx = 0;
  String status = '';
  int selected_category = 1;
  int selected_sub_category = 1;

  List categorylist_data = [];
  List<Category_list> categorylist_string = [];

  List sub_categorylist_data = [];
  List<SubCategory_list> sub_categorylist_string = [];

  List local_ad_data = [];
  List<LocalAd_list> local_ad_string = [];

  List blog_data = [];
  List<Blog_Detail_list> blog_string = [];
  String CategoryName = '';
  int _currentIndex = 0;

  String BlogPostId = '';
  String Heading = '';
  String HText = '';
  String PostDisplayPhoto = '';
  String TimeAgo = '';
  String SubCategoryName = '';
  String PostImage1 = '';
  String PostImage2 = '';
  String PostImage3 = '';
  String PostImage4 = '';
  String PostImage5 = '';
  String PostCategory = '';
  String PostSubCategory = '';
  String VideoLink = '';
  String ShareText = '';
  String PostByName = '';
  String WhatsappNumber = '';
  String WhatsappText = '';
  String ShareLink = '';
  String videoId = '';
  String Status = '';
  String RejectionComment = '';
  String EndDate = '';
  String TotalClicks = '';
  String AreaName = '';
  bool _isLoading = false;
  Blog_Detail_list? blog;

  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '${videoId}',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  List<String> dummyNames = [];
  List<String> dummyInitials = [];
  int dummyTotalMembers = 0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () {
      GetBlogData();
    });
    Timer(shimmerDuration, () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void selectItem(int index, String cat_id) {
    setState(() {
      selected_category = int.parse(cat_id);
      GetBlogData();
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

  void onItemClicked(int index, String subcat_id) {
    setState(() {
      selectedIdx_2 = index;
      selected_sub_category = int.parse(subcat_id);
    });
    // getBlogData();
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  showLoaderDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: 80, // Dialog width
              height: 80, // Dialog height
              child: SingleChildScrollView(
                child: Image.asset(
                  "assets/images/loader.gif",
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> GetBlogData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final url = Config.get_blog_data;
      final deviceId = await DeviceHelper.getDeviceId();

      final response = await http.post(
        Uri.parse(url),
        body: {
          'category_id': widget.PostCategory,
          'subcategory_id': widget.PostSubCategory,
          'post_id': widget.BlogPostId,
          'user_id': deviceId ?? '',
        },
      );

      logger.i("$url\n${response.statusCode}\n${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Server Error");
      }

      final Map<String, dynamic> data = json.decode(response.body);
      status = data["success"];

      if (status != "0") {
        throw Exception("API returned error");
      }

      /// ---------- PARSE DATA (NO UI BLOCKING) ----------
      categorylist_string = (data['data']['category'] as List)
          .map((e) => Category_list.fromJson(e))
          .toList();

      sub_categorylist_string = (data['data']['sub_category'] as List)
          .map((e) => SubCategory_list.fromJson(e))
          .toList();

      local_ad_string = (data['data']['local_ad'] ?? [])
          .map<LocalAd_list>((e) => LocalAd_list.fromJson(e))
          .toList();

      final blogList = (data['data']['blog'] as List)
          .map((e) => Blog_Detail_list.fromJson(e))
          .toList();

      if (blogList.isEmpty) {
        throw Exception("No blog data");
      }

      /// ---------- SINGLE BLOG OBJECT ----------
      blog = blogList.first;
// ---------- DUMMY USERS ----------
      final dummy = data['data']['dummy_users'];

      if (dummy != null) {
        dummyNames = List<String>.from(dummy['names'] ?? []);
        dummyInitials = List<String>.from(dummy['initials'] ?? []);
        dummyTotalMembers = dummy['total_members'] ?? 0;
      }

      /// ---------- YOUTUBE INIT (ONLY IF NEEDED) ----------
      if (blog!.VideoLink != null && blog!.VideoLink!.isNotEmpty) {
        final id = YoutubePlayer.convertUrlToId(blog!.VideoLink!);
        if (id != null) {
          videoId = id;
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        CategoryName = blog!.CategoryName ?? '';
        Heading = blog!.Heading ?? '';
        HText = blog!.Text ?? '';
        PostDisplayPhoto = blog!.PostDisplayPhoto ?? '';
        SubCategoryName = blog!.SubCategoryName ?? '';

        PostImage1 = blog!.PostImage1 ?? '';
        PostImage2 = blog!.PostImage2 ?? '';
        PostImage3 = blog!.PostImage3 ?? '';
        PostImage4 = blog!.PostImage4 ?? '';
        PostImage5 = blog!.PostImage5 ?? '';

        ShareText = blog!.ShareText ?? '';
        PostByName = blog!.PostByName ?? '';
        ShareLink = blog!.ShareLink ?? '';
        TimeAgo = blog!.TimeAgo ?? '';
        Status = blog!.Status ?? '';
        RejectionComment = blog!.RejectionComment ?? '';
        WhatsappNumber = blog!.WhatsappNumber ?? '';
        WhatsappText = blog!.WhatsappText ?? '';
        EndDate = blog!.EndDate ?? '';
        TotalClicks = blog!.TotalClicks ?? '';
        AreaName = blog!.Area == "null" ? '' : blog!.Area ?? '';

        showShimmer = false;
        _isLoading = false;
      });
    } catch (e, stack) {

      if (mounted) {
        setState(() {
          _isLoading = false;
          showShimmer = false;
        });

        Fluttertoast.showToast(
          msg: "Failed to load post",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
      false, // Prevent user from dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Are you sure you want to delete this post?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Call delete_post() or perform deletion logic here
                Navigator.of(context).pop(); // Close the dialog
                delete_post();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ad_response(ad_id) async {
    var url = Config.insert_ad_response;
    String deviceId = await DeviceHelper.getDeviceId();
    print('deviceId${deviceId}');
    print('ad_id${ad_id}');
    http.Response response = await http.post(Uri.parse(url),
        body: {"user_id": '${deviceId}', "ad_id": '${ad_id}'});

    logger.i("${url} \n${response.statusCode} \n${''}");
  }

  delete_post() async {
    showLoaderDialog(context);
    String deviceId = await DeviceHelper.getDeviceId();

    var url = Config.delete_post;
    http.Response response = await http.post(Uri.parse(url),
        body: {'BlogPostId': '${widget.BlogPostId}', 'user_id': '${deviceId}'});

    logger.i("${url} \n${response.statusCode} \n${''}");

    Map<String, dynamic> data = json.decode(response.body);
    status = data["success"];
    if (status == "0") {
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 15.0);
      Navigator.of(context).pop();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyPostScreen(false)));
    } else {
      Navigator.of(context).pop();

      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 15.0);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyPostScreen(false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white, // Change app bar color to white
          elevation: 0.0, // Remove the bottom border
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: const IconThemeData(
              color: Colors.black), // Change icon color to black
          // textTheme: TextTheme(
          //   headline6: TextStyle(color: Colors.black), // Change text color to black
          // ),

          centerTitle: true,
          title: Row(
            children: [
              Text('${CategoryName}',
                  style: const TextStyle(
                    color: Colors.black,
                  )),
            ],
          ),
          actions: [
            if (widget.FromMyPost == true) ...[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ]
          ],
        ),
        body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        color: kDebugMode ? Colors.grey.shade300 : Colors.white,
                        margin: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (VideoLink != '') ...[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                                  videoId: videoId)));
                                },
                                child: Stack(
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

                                /*YoutubePlayer(
                                    controller: _controller,
                                    aspectRatio: 16 / 9,
                                  ),*/
                              ),
                            ] else ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageViewer(
                                              PostDisplayPhoto,
                                              PostImage1,
                                              PostImage2,
                                              PostImage3,
                                              PostImage4,
                                              PostImage5,
                                              0,
                                              'blog')));
                                },
                                child: showShimmer
                                    ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 380,
                                    color: Colors.white,
                                  ),
                                )
                                    : Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                    imageUrl: Config.Image_Path +
                                        'blog/${PostDisplayPhoto}',
                                  ),
                                ),
                              )
                            ],
                            const SizedBox(height: 10.0),
                            Center(
                              child: Row(
                                children: [
                                  if (VideoLink != '') ...[
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
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        0,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              6.5,
                                          height: 80,
                                          imageUrl: Config.Image_Path +
                                              'blog/${PostDisplayPhoto}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              )),
                                    ),
                                  ],
                                  if (PostImage1 != '') ...[
                                    const SizedBox(width: 10),
                                    showShimmer
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 300,
                                        height: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        1,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              6.5,
                                          height: 80,
                                          imageUrl: Config.Image_Path +
                                              'blog/${PostImage1}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              )),
                                    ),
                                  ],
                                  if (PostImage2 != '') ...[
                                    const SizedBox(width: 10),
                                    showShimmer
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        // width: double.infinity,
                                        width: 300,
                                        height: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        2,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            6.5,
                                        height: 80,
                                        imageUrl: Config.Image_Path +
                                            'blog/${PostImage2}',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                      ),
                                    )
                                  ],
                                  if (PostImage3 != '') ...[
                                    const SizedBox(width: 10),
                                    showShimmer
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        3,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            6.5,
                                        height: 80,
                                        imageUrl: Config.Image_Path +
                                            'blog/${PostImage3}',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                      ),
                                    )
                                  ],
                                  if (PostImage4 != '') ...[
                                    const SizedBox(width: 10),
                                    showShimmer
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        4,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            6.5,
                                        height: 80,
                                        imageUrl: Config.Image_Path +
                                            'blog/${PostImage4}',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                            Image.asset(
                                              "assets/images/loader.gif",
                                              width: 80,
                                              height: 80,
                                            ),
                                      ),
                                    )
                                  ],
                                  if (PostImage5 != '') ...[
                                    const SizedBox(width: 10),
                                    showShimmer
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                        PostDisplayPhoto,
                                                        PostImage1,
                                                        PostImage2,
                                                        PostImage3,
                                                        PostImage4,
                                                        PostImage5,
                                                        5,
                                                        'blog')));
                                      },
                                      child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              6.5,
                                          height: 80,
                                          imageUrl: Config.Image_Path +
                                              'blog/${PostImage5}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Image.asset(
                                                "assets/images/loader.gif",
                                                width: 80,
                                                height: 80,
                                              )),
                                    )
                                  ],
                                ],
                              ),
                            ),


                            //Post By Name
                            showShimmer
                                ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                color: Colors.white,
                              ),
                            )
                                : (PostByName.toString()!="null"&&PostByName.toString()!="")?Container(
                              color: kDebugMode? Colors.red:null,
                              padding: const EdgeInsets.only(left: 0),
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 22,
                                    margin:
                                    const EdgeInsets.only(left: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        PostByName[0],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    PostByName,
                                    style:
                                    StyleConfiguration.areaTextStyle,
                                  ),
                                  // Add spacing between the icon and text
                                ],
                              ),
                            ):SizedBox(),


                            if (AreaName != "null" && AreaName.length > 0)
                              Container(
                                color: kDebugMode? Colors.red:null,
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 24,
                                        height: 22,
                                        margin: const EdgeInsets.only(
                                            left: 0, bottom: 2),
                                        decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Icon(Icons.location_pin))),
                                    Expanded(
                                      child: Text(
                                        AreaName,
                                        style: StyleConfiguration.areaTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            //Area
                            //   if(AreaName!='null'&&AreaName.isNotEmpty)
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(horizontal: 10,),
                            //       child: Row(
                            //         children: [
                            //           Icon(Icons.location_pin),
                            //           Text("$AreaName",style: TextStyle(fontWeight: FontWeight.w500),),
                            //         ],
                            //       ),
                            //     ),
                            //   const SizedBox(height: 10,),

                            /*  showShimmer
                                  ?
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                ),
                              )
                                  :  Container(
                                padding: const EdgeInsets.only(left:10),
                                child:  Html(
                                  data:'${Heading}',

                                ),
                              ),
                              */

                            // const SizedBox(height: 10.0),
                            showShimmer
                                ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: 5, // Number of lines
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          margin:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 20.0),
                                          width: double.infinity,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                5.0),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            )
                                : Container(
                              color: kDebugMode? Colors.red.withOpacity(.3):null,
                              margin: EdgeInsets.only(top: 0),
                              padding: const EdgeInsets.only(left: 0),
                              child:  HtmlWidget(
                               HText ?? '',
                                onTapUrl: (url) async {
                                  if (await canLaunch(url)) {
                                    await launch(url); // ✅ String version
                                  }
                                  return true;
                                },
                              )
                            ),



                            if (ShareText != '') ...[
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (ShareLink != '') {
                                        launchUrl(ShareLink);
                                      } else {
                                        launchUrl(
                                            "https://wa.me/+91${WhatsappNumber}?text=${WhatsappText}");
                                      }
                                      // Add your button click logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors
                                          .black, // Set the background color to black
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(
                                        '${ShareText}',
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            /*if(WhatsappNumber!='')...[
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        launchUrl("https://wa.me/+91${WhatsappNumber}?text=${WhatsappText}");
                                        // Add your button click logic here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        primary: Colors.black, // Set the background color to black
                                      ),
                                      child:
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                                        child:
                                        Text(
                                          '${ShareText}',
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
                                            '${TimeAgo}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ]*/
                          ],
                        ),
                      ),
                      if (local_ad_string.length > 0) ...[
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    ad_response(local_ad_string[0].AdId);

                                    if (local_ad_string[0].Url != '') {
                                      launchUrl(local_ad_string[0].Url);
                                    } else {
                                      String w_no =
                                          local_ad_string[0].WhatsappNumber;
                                      String w_msg =
                                          local_ad_string[0].WhatsappText;
                                      String url =
                                          "https://wa.me/+91${w_no}?text=${w_msg}";
                                      if (local_ad_string[0].Url != '') {
                                        url = local_ad_string[0].Url;
                                      }

                                      launchUrl(url);
                                    }
                                  },
                                  child: CachedNetworkImage(fadeInDuration: Duration.zero, fadeOutDuration: Duration.zero,
                                      imageUrl: Config.Image_Path +
                                          'local_ad/${local_ad_string[0].AdImage}',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/images/loader.gif",
                                            width: 80,
                                            height: 80,
                                          )))
                            ],
                          ),
                        ),
                      ],
                      const Divider(),
                      if (widget.FromMyPost == true) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (Status == 'Pending Approval') ...[
                                Image.asset(
                                  'assets/images/PendingApproval.png',
                                  height: 16.0,
                                )
                              ] else if (Status == 'Expired') ...[
                                Image.asset(
                                  'assets/images/Expired.png',
                                  height: 16.0,
                                )
                              ] else if (Status == 'Approved') ...[
                                Image.asset(
                                  'assets/images/Approved.png',
                                  height: 16.0,
                                )
                              ] else if (Status == 'Rejected') ...[
                                Image.asset(
                                  'assets/images/Rejected.png',
                                  height: 16.0,
                                )
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 16.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                '${TimeAgo}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (EndDate != '01 Jan 1970') ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  'Expires On : ${EndDate}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        if (Status == 'Approved') ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  'Total Views:${TotalClicks}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (RejectionComment != ''&&Status=="Rejected") ...[
                          Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Rejection Reason: ${RejectionComment}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ))
                        ]
                      ],
                      if (dummyNames.isNotEmpty && Status=='Approved') ...[
                        Container(
                          height: 70,
                          child:
    GroupPreviewTileBlog(
    initials: dummyInitials,
    titleText: dummyNames.join(', '), // "test, best"
    membersOnline: "${dummyTotalMembers}",
    )

                        ),

                        const SizedBox(height: 8),
                      ],

                    ],
                  ),
                ))));
  }

  Future _refreshData() async {
    GetBlogData();
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
