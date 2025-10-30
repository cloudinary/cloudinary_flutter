import 'dart:async';

import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/video/cld_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CloudinaryObject? cloudinary;
  CldVideoController? videoController;

  @override
  void initState() {
    super.initState();
    initCloudinary();
  }

  Future<void> initCloudinary() async {
    final obj = CloudinaryObject.fromCloudName(cloudName: 'dwij7l73v');
    final controller = CldVideoController(
      cloudinary: obj,
      publicId: 'samples/cld-sample-video',
    );
    await controller.initialize();

    // If the widget was removed from the tree while cloudinary object
    // was initialising, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      cloudinary = obj;
      videoController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              videoController?.value.isPlaying == true
                  ? videoController?.pause()
                  : videoController?.play();
            });
          },
          child: Icon(
            videoController?.value.isPlaying == true
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        body: Center(
          child: cloudinary == null || videoController == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 140,
                      child: CldImageWidget(
                        cloudinary: cloudinary!,
                        // This sample is existent on newly created workspaces
                        publicId: "samples/logo",
                        // Many images can be easily re-tinted
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 384,
                      height: 216,
                      child: VideoPlayer(videoController!),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
