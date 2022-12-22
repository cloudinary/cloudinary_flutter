import 'package:cloudinary_dart/cloudinary.dart';
import 'package:cloudinary_flutter/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:flutter/material.dart';

void main() {
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "<your_cloud_name>");
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
              publicId: "dog",
            ),
          ),
        ),
      ),
    );
  }
}
