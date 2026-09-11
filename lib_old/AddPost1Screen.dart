import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

import 'AddPost2Screen.dart';
import 'MultiImagePicker.dart';

class AddPost1Screen extends StatefulWidget {
  final String categoryId,Desc;

  AddPost1Screen(this.categoryId,this.Desc);

  @override
  _AddPost1ScreenState createState() => _AddPost1ScreenState();
}

class _AddPost1ScreenState extends State<AddPost1Screen> {
  List<String> imagePaths = [];
  String image_1='';
  String image_2='';
  String image_3='';
  String image_4='';
  late PermissionStatus _permissionStatus;
  late BuildContext _context;
  TextEditingController desc_con = new TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _context = context;
  }

  @override
  void dispose() {
    // Now you can safely use _context in dispose()
    super.dispose();
  }

  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;
    if (Platform.isIOS) {
      //perm = await permissionPhotos();
    } else if (Platform.isAndroid) {
      // final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      // final int sdkInt = android.version.sdkInt ?? 0;
      // print('sdkInt${sdkInt}');
      // if(sdkInt>32)
      {
        final PermissionStatus try1 = await Permission.photos.request();
        final PermissionStatus try2 = await Permission.camera.request();

        final PermissionStatus try3 = await Permission.storage.request();
        final PermissionStatus try4 = await Permission.camera.request();

      }

    } else {}
    return Future<bool>.value(perm);
  }

  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 4,

        selectedAssets: images,
      );
    } on Exception catch (e) {
      print("loadasset${e}");
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
  List<File> _selectedImages = [];


  Future<String?> selectImage() async {

    setState(() {

      desc_con.text=widget.Desc.replaceAll("\\n", "\n");;
    });

    // Instantiate ImagePicker
    ImagePicker imagePicker = ImagePicker();

    // Use getImage method to pick an image from the gallery
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    // Check if image was picked
    if (pickedFile != null) {
      // Return the path of the picked image
      setState(() {

        image_1=pickedFile.path;
      });
      print('image_1${image_1}');
      // Delay the focus request slightly to ensure UI updates are complete
      Future.delayed(const Duration(milliseconds: 300), () {
        // Request focus on the TextField after the UI updates
        FocusScope.of(context).requestFocus(focusNode);
        // Show the keyboard after focusing
        FocusScope.of(context).focusedChild!.requestFocus();
        _moveCursorToEnd();
      });
    } else {
      // No image was picked, return null
      return null;
    }
    FocusScope.of(context).requestFocus(focusNode);

  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    int remainingSlots =3 - _selectedImages.length; // Calculate remaining slots
    if (remainingSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only select up to 4 images.'),
          duration: Duration(seconds: 2),
        ),
      );
      // If no remaining slots, show a message or limit further selection
      return;
    }

    final pickedImages = await picker.pickMultiImage(
      imageQuality: 100,
    );

    if (pickedImages != null) {
      setState(() {
          _selectedImages.addAll(pickedImages.take(remainingSlots).map((image) => File(image.path)));

      });
    }
    FocusScope.of(context).requestFocus(focusNode);
  }



  void removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });

  }
  void removeImage_DP(int index) {
    setState(() {
      image_1='';
    });
    selectImage();

  }
  _storeText(String text) {
    // Replace new lines with appropriate representation before saving to database
    String sanitizedText = text.replaceAll('\n', '\\n');
    // Simulate storing to database
    return sanitizedText;

  }
  void _moveCursorToEnd() {
    desc_con.selection = TextSelection.fromPosition(
        TextPosition(offset: desc_con.text.length));
  }
  @override
  void initState() {
    focusNode.requestFocus(); // Request focus when the widget initializes

    Future.delayed(Duration(milliseconds: 1), () {
     permissionPhotoOrStorage();
      //_pickImages();
     selectImage();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white, // Change app bar color to white
        elevation: 0.0, // Remove the bottom border
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Change icon color to black
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.black), // Change text color to black
        // ),

        centerTitle: true,
// Back arrow
        title: Row(
          children: const [
            // Add spacing between the image and text
            Text('Add Images',
                style:TextStyle(color: Colors.black,)),
          ],
        ),
        actions: [
          SizedBox(
            height: 20, // Adjust height as needed
            child: GestureDetector(
              onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddPost2Screen('${widget.categoryId}','${_storeText(desc_con.text)}',_selectedImages,image_1)));


              },
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  color:Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),

                child: const Center(
                  child:  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Adjust font size as needed
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey, spreadRadius: 1),
                ],
              ),
              child:
              TextFormField(
                controller: desc_con,
                focusNode: focusNode,
                autofocus: true,
                maxLines: null, // Allows unlimited lines
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  border: InputBorder.none,


                ),
              ),
            ),

            if(image_1!='')...[


            SizedBox(height: 20),
            // Display images
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child:image_1==''
                  ? GestureDetector(
                  onTap: () {
                  selectImage();
                  },
                  child: Image.asset(
              'assets/images/picture_icon.png',
                width: 120.0,
                height: 120.0,
                fit: BoxFit.fill,
              )): Center(
                child: Stack(
                  children: [
                    Image.file(File(image_1),
                    width: 300,
                    height: 300,),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => removeImage_DP(0),
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child:  Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // White background color
                          shape: BoxShape.circle, // Circular shape
                        ),
                        padding: EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 20.0, // Adjust font size as needed
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            if(_selectedImages.length!=0)...[

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),

                  child:GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: List.generate(_selectedImages.length, (index) {
                  return Stack(
                    children: [
                      Image.file(_selectedImages[index],
                        width: 300,
                        height: 300,),


                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => removeImage(index),
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          child:  Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // White background color
                              shape: BoxShape.circle, // Circular shape
                            ),
                            padding: EdgeInsets.all(8.0), // Adjust padding as needed
                            child: Text(
                              '${index+2}',
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Text color
                              ),
                            ),
                          )

                      ),
                    ],
                  );
                }),
              ),
              ),
              ],
              SizedBox(height: 40),


            // Add more photos button
            if (_selectedImages.length < 3 && image_1!='')
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60.0), // Add margin on both sides
                child:
                GestureDetector(
                  onTap: () {
                   // loadAssets();
                    _pickImages();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '+ Add More Photos',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(width: 10.0),
                        Image.asset(
                          'assets/images/picture_icon.png',
                          width: 34.0,
                          height: 54.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (_selectedImages.length == 3)
              Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Max 4 Photos allowed.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )


          ],

        ),
      ),
    );
  }
}