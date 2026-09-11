import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}
class _ImagePickerPageState extends State<ImagePickerPage> {
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    int remainingSlots = 4 - _selectedImages.length; // Calculate remaining slots
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
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedImages != null) {
      setState(() {
        // Add the newly picked images to the existing list, up to remainingSlots
        _selectedImages.addAll(pickedImages.take(remainingSlots).map((image) => File(image.path)));
      });
    }
  }

  Future<void> _uploadImages() async {
    // You can implement your REST API endpoint here
    // For example, you can use http package to make POST request
    // Ensure to convert images to base64 before sending if required

    // Dummy example to print image paths
    _selectedImages.forEach((image) {
      print(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: _selectedImages
                  .map(
                    (image) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.file(image),
                ),
              )
                  .toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Select Images'),
          ),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Text('Upload Images'),
          ),
        ],
      ),
    );
  }
}