import 'package:cloudinary_dart/asset/cld_video.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CldVideoWidget extends StatefulWidget {
  late final CldVideo video;
  late final VideoPlayerController _controller;
  final VideoProgressColors? videoProgressColors;
  CldVideoWidget(
      {required String publicId,
      super.key,
      String? version,
      String? extension,
      String? urlSuffix,
      String? assetType,
      String? deliveryType,
      Transformation? transformation,
      this.videoProgressColors}) {
    video = CloudinaryContext.cloudinary.video(publicId);
    ((version != null) ? video.version(version) : null);
    ((extension != null) ? video.extension(extension) : null);
    ((urlSuffix != null) ? video.urlSuffix(urlSuffix) : null);
    ((assetType != null) ? video.assetType(assetType) : null);
    ((deliveryType != null) ? video.deliveryType(deliveryType) : null);
    ((transformation != null) ? video.transformation(transformation) : null);
  }

  @override
  State<StatefulWidget> createState() {
    return _CldVideoState();
  }
}

class _CldVideoState extends State<CldVideoWidget> {
  @override
  void initState() {
    super.initState();
    widget._controller = VideoPlayerController.network(widget.video.toString(),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    widget._controller.addListener(() {
      setState(() {});
    });
    widget._controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        VideoPlayer(widget._controller),
        _ControlsOverlay(controller: widget._controller),
        VideoProgressIndicator(
          widget._controller,
          allowScrubbing: true,
          colors: widget.videoProgressColors ??
              const VideoProgressColors(playedColor: Colors.blue),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
