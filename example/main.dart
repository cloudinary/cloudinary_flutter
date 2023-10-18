import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/material.dart';

late CloudinaryObject cloudinary;

void main() {
  cloudinary = CloudinaryObject.fromCloudName(cloudName: '<your_cloud_name>');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            height: 140,
            child: CldImageWidget(
              cloudinary: cloudinary,
              publicId: "dog",
            ),
          ),
        ),
      ),
    );
  }
}
