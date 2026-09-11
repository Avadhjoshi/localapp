import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'constants/Config.dart';

class ImageViewer extends StatefulWidget {
  final String PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,Folder;
  final int initialIndex;
  ImageViewer(this.PostDisplayPhoto,this.PostImage1,this.PostImage2,this.PostImage3,this.PostImage4,this.PostImage5,this.initialIndex,this.Folder);

  @override
  _MyImageViewer createState() => _MyImageViewer(PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,Folder);
}

class _MyImageViewer extends State<ImageViewer> {
  final String PostDisplayPhoto,PostImage1,PostImage2,PostImage3,PostImage4,PostImage5,Folder;
  _MyImageViewer(this.PostDisplayPhoto,this.PostImage1,this.PostImage2,this.PostImage3,this.PostImage4,this.PostImage5,this.Folder);
  late PageController _pageController;
  List<String> imageUrls = [];
  bool prev_btn=false;
  bool next_btn=true;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.initialIndex);

    imageUrls = [
      Config.Image_Path+'${widget.Folder}/${widget.PostDisplayPhoto}',
      if(PostImage1!='')
        Config.Image_Path+'${widget.Folder}/${widget.PostImage1}',
      if(PostImage2!='')
        Config.Image_Path+'${widget.Folder}/${widget.PostImage2}',
      if(PostImage3!='')
        Config.Image_Path+'${widget.Folder}/${widget.PostImage3}',
      if(PostImage4!='')
        Config.Image_Path+'${widget.Folder}/${widget.PostImage4}',
      if(PostImage5!='')
        Config.Image_Path+'${widget.Folder}/${widget.PostImage5}',
    ];

    Future.delayed(Duration.zero, () {
      setState(() {
        prev_btn=true;
        if(widget.initialIndex==0)
          {
            prev_btn=false;
          }
        if(widget.initialIndex==imageUrls.length-1)
        {
          next_btn=false;
        }
      });
    });
    //show_loader();
  }
  show_loader(){
    showLoaderDialog(context);

    Future.delayed(Duration(seconds: 2), ()
    {
      Navigator.of(context).pop();
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            child:  PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              loadingBuilder: (context, event) {
                if (event == null) {
                  // Image is still loading
                  return Center(
                    child: Image.asset(
                      "assets/images/loader.gif",
                      width: 80,
                      height: 80,


                    ),
                  );
                } else {
                  // Image has loaded
                  return Container(); // You can return an empty container or another widget
                }
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.white,
              ),
              pageController: _pageController,
              onPageChanged: (index) {
                // Handle page change, if needed
              },
            ),

          ),
            Positioned(
              top: 80,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.black,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

          if(prev_btn==true)...[

      Positioned(
            left: 10,
            child:

            GestureDetector(
              onTap: (){
                showLoaderDialog(context);
                setState(() {
                  print('current${widget.initialIndex}');
                  if(_pageController.page==1)
                  {
                    prev_btn=false;
                  }
                  else{
                    next_btn=true;
                    prev_btn=true;
                  }
                });

                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop();

                });
              },
              child:
              Container(
                width: 30,
                height: 40,
                padding: EdgeInsets.all(5), // Adjust padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.arrow_back_ios, color: Colors.grey),



              ),
            ),
          ),
          ],


      if(next_btn==true)...[
        Positioned(
            right: 10,
            child:
            GestureDetector(
              onTap: (){
                showLoaderDialog(context);
                setState(() {
                  if(_pageController.page==imageUrls.length-2)
                    {
                      next_btn=false;
                    }
                  else{
                    next_btn=true;
                    prev_btn=true;
                  }
                });
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop();

                });
              },
              child:  Container(
                width: 30,
                height: 40,
                padding: EdgeInsets.all(5), // Adjust padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child:  Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
            )


        ),

      ]

        ],
      ),
    );
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
                child:Image.asset(
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

}


