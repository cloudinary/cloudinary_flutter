import 'package:cloudinary_url_gen/asset/cld_video.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/video_edit/transcode/transcode.dart';
import 'package:cloudinary_url_gen/transformation/video_edit/transcode/transcode_actions.dart';
import 'package:video_player/video_player.dart';
import '../cloudinary_context.dart';
import 'analytics/video_analytics.dart';
import 'analytics/video_events_manager.dart';

import 'dart:ui';

class CldVideoController extends VideoPlayerController
    with VideoControllerListeners {
  late final Uri uri;
  @override
  late VideoEventsManager eventsManager;
  var analytics = true;
  String? publicId;

  @override
  Future<void> initialize() async {
    await super.initialize();

    uri = Uri.parse(dataSource!);
    eventsManager = VideoEventsManager();

    addCustomListeners();
  }

  @override
  Future<void> dispose() async {
    eventsManager.sendViewEndEvent();
    eventsSent.viewEndSent = true;
    eventsManager.sendEvents();
    super.dispose();
  }

  CldVideoController.networkUrl(Uri url) : super.networkUrl(url) {
    uri = url;
    eventsManager = VideoEventsManager();
  }

  CldVideoController({
    required String publicId,
    Cloudinary? cloudinary,
    String? version,
    String? extension,
    String? urlSuffix,
    String? assetType,
    String? deliveryType,
    Transformation? transformation,
    bool? automaticStreamingProfile,
  }) : super.networkUrl(_buildVideoUri(
            publicId,
            cloudinary,
            version,
            extension,
            urlSuffix,
            assetType,
            deliveryType,
            transformation,
            automaticStreamingProfile)) {
    eventsManager = VideoEventsManager(
        cloudName: cloudinary?.config.cloudConfig.cloudName,
        publicId: publicId);
  }

  static Uri _buildVideoUri(
    String publicId,
    Cloudinary? cloudinary,
    String? version,
    String? extension,
    String? urlSuffix,
    String? assetType,
    String? deliveryType,
    Transformation? transformation,
    bool? automaticStreamingProfile,
  ) {
    cloudinary ??= CloudinaryContext.cloudinary;
    CldVideo video = cloudinary.video(publicId);
    ((version != null) ? video.version(version) : null);
    ((extension != null) ? video.extension(extension) : null);
    ((urlSuffix != null) ? video.urlSuffix(urlSuffix) : null);
    ((assetType != null) ? video.assetType(assetType) : null);
    ((deliveryType != null) ? video.deliveryType(deliveryType) : null);

    if ((automaticStreamingProfile == null || automaticStreamingProfile) &&
        transformation == null) {
      video.transformation(Transformation()
          .transcode(Transcode.streamingProfile(StreamingProfile.auto())));
      video.extension('m3u8');
    } else {
      ((transformation != null) ? video.transformation(transformation) : null);
    }
    return Uri.parse(video.toString());
  }

  void setAnalytics(AnalyticsType analyticsType,
      {String? cloudName, String? publicId}) {
    switch (analyticsType) {
      case AnalyticsType.auto:
        eventsManager.trackingType = TrackingType.auto;
        eventsManager.cloudName = cloudName ?? eventsManager.publicId;
        eventsManager.publicId = publicId ?? this.publicId;
        break;
      case AnalyticsType.manual:
        eventsManager.trackingType = TrackingType.manual;
        eventsManager.cloudName = cloudName ?? eventsManager.cloudName;
        eventsManager.publicId = publicId ?? this.publicId;
        break;
      case AnalyticsType.disabled:
        analytics = false;
        removeListeners();
        break;
    }
  }
}

mixin VideoControllerListeners on VideoPlayerController {
  late VideoEventsManager eventsManager;
  late Uri uri;

  VoidCallback? _listener1;
  VoidCallback? _listener2;

  var eventsSent = EventsSent();
  // Add your listeners here
  void addCustomListeners() {
    // Listener for video status
    _listener1 = () {
      if (value.isInitialized && !eventsSent.viewStartSent) {
        eventsManager.sendViewStartEvent(uri.toString());
        eventsSent.viewStartSent = true;
      }
      if (value.isPlaying && !eventsSent.playedSent) {
        eventsManager.sendPlayEvent();
        eventsSent.pausedSent = false;
        eventsSent.playedSent = true;
      }
      if (!value.isPlaying && eventsSent.playedSent) {
        eventsManager.sendPauseEvent();
        eventsSent.pausedSent = true;
        eventsSent.playedSent = false;
      }
    };

    _listener2 = () {
      if (!eventsSent.loadMetadataSent) {
        eventsManager.sendLoadMetadataEvent(value.duration.inMilliseconds);
        eventsSent.loadMetadataSent = true;
      }
    };

    addListener(_listener1!);
    addListener(_listener2!);
  }

  void removeListeners() {
    if (_listener1 != null) {
      removeListener(_listener1!);
    }
    if (_listener2 != null) {
      removeListener(_listener2!);
    }
  }
}

class EventsSent {
  var viewStartSent = false;
  var viewEndSent = false;
  var loadMetadataSent = false;
  var playedSent = false;
  var pausedSent = false;
}
