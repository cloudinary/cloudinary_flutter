import '../../cloudinary_object.dart';

typedef EventDetails = Map<String, dynamic>;
typedef CustomerData = Map<String, dynamic>;
typedef VideoData = Map<String, dynamic>;
typedef ProvidedData = Map<String, dynamic>;

enum TrackingType {
  manual('manual'),
  auto('auto');

  final String value;
  const TrackingType(this.value);
}

enum PlayerKeyPath { status, timeControlStatus, duration }

enum AnalyticsType { auto, manual, disabled }

class VideoPlayerObject {
  final String type;
  final String version;

  VideoPlayerObject({required this.type, required this.version});
}

class VideoEvent {
  TrackingType trackingType;
  String eventName;
  int eventTime;
  EventDetails eventDetails;

  VideoEvent({
    required this.trackingType,
    required this.eventName,
    EventDetails? eventDetails,
  })  : eventTime = DateTime.now().millisecondsSinceEpoch,
        eventDetails = eventDetails ?? {};

  static Map<String, dynamic> createVideoPlayerObject() {
    return {
      VideoEventJSONKeys.type.name: 'flutter_player',
      VideoEventJSONKeys.version.name: sdkVersion
    };
  }

  Map<String, dynamic> createCustomerData(
      Map<String, String>? trackingData, Map<String, dynamic>? providedData) {
    var videoData = VideoData();
    videoData[VideoEventJSONKeys.cloudName.name] =
        trackingData?[VideoEventJSONKeys.cloudName.name] ?? '';
    videoData[VideoEventJSONKeys.publicId.name] =
        trackingData?[VideoEventJSONKeys.publicId.name] ?? '';

    var result = {VideoEventJSONKeys.videoData.name: videoData};

    if (providedData != null && providedData.isNotEmpty) {
      var providedDataObject = <String, dynamic>{};
      providedData.forEach((key, value) {
        providedDataObject[key] = value;
      });
      result[VideoEventJSONKeys.providedData.name] = providedDataObject;
    }

    return result;
  }

  Map<String, dynamic> toDictionary() {
    var detailsDictionary = Map<String, dynamic>.from(eventDetails);

    return {
      VideoEventJSONKeys.eventName.name: eventName,
      VideoEventJSONKeys.eventTime.name: eventTime,
      VideoEventJSONKeys.eventDetails.name: detailsDictionary,
    };
  }

  static EventDetails _createEventDetails(
    TrackingType trackingType,
    String videoUrl,
    Map<String, String>? trackingData,
    Map<String, dynamic>? providedData,
  ) {
    var eventDetails = {
      VideoEventJSONKeys.trackingType.name: trackingType.value,
      VideoEventJSONKeys.videoUrl.name: videoUrl,
      VideoEventJSONKeys.customerData.name:
          _createCustomerData(trackingData, providedData),
      VideoEventJSONKeys.videoPlayer.name: createVideoPlayerObject()
    };
    return Map.from(eventDetails);
  }

  static CustomerData _createCustomerData(
    Map<String, String>? trackingData,
    Map<String, dynamic>? providedData,
  ) {
    var videoData = {
      VideoEventJSONKeys.cloudName.name:
          trackingData?[VideoEventJSONKeys.cloudName.name] ?? '',
      VideoEventJSONKeys.publicId.name:
          trackingData?[VideoEventJSONKeys.publicId.name] ?? ''
    };

    Map<String, dynamic> result = {
      VideoEventJSONKeys.videoData.name: videoData
    };

    if (providedData != null && providedData.isNotEmpty) {
      var providedDataObject = Map<String, dynamic>.from(providedData);
      result[VideoEventJSONKeys.providedData.name] = providedDataObject;
    }

    return Map.from(result);
  }
}

class VideoViewStartEvent extends VideoEvent {
  VideoViewStartEvent({
    TrackingType trackingType = TrackingType.auto,
    required String videoUrl,
    Map<String, String>? trackingData,
    Map<String, dynamic>? providedData,
  }) : super(
          trackingType: trackingType,
          eventName: EventNames.viewStart.value,
          eventDetails: VideoEvent._createEventDetails(
            trackingType,
            videoUrl,
            trackingData,
            providedData,
          ),
        );
}

class VideoLoadMetadata extends VideoEvent {
  VideoLoadMetadata({
    TrackingType trackingType = TrackingType.auto,
    required int duration,
    Map<String, dynamic>? providedData,
  }) : super(
          trackingType: trackingType,
          eventName: EventNames.loadMetadata.value,
          eventDetails: {
            VideoEventJSONKeys.trackingType.name: trackingType.value,
            VideoEventJSONKeys.videoDuration.name: duration,
          },
        );
}

class VideoViewEnd extends VideoEvent {
  VideoViewEnd({
    TrackingType trackingType = TrackingType.auto,
    Map<String, dynamic>? providedData,
  }) : super(
          trackingType: trackingType,
          eventName: EventNames.viewEnd.value,
          eventDetails: {
            VideoEventJSONKeys.trackingType.name: trackingType.value
          },
        );
}

class VideoPlayEvent extends VideoEvent {
  VideoPlayEvent(
      {TrackingType trackingType = TrackingType.auto,
      Map<String, dynamic>? providedData})
      : super(
          trackingType: trackingType,
          eventName: EventNames.play.value,
        );
}

class VideoPauseEvent extends VideoEvent {
  VideoPauseEvent({TrackingType trackingType = TrackingType.auto})
      : super(
          trackingType: trackingType,
          eventName: EventNames.pause.value,
        );
}

enum VideoEventJSONKeys {
  userId,
  trackingType,
  viewId,
  events,
  eventName,
  eventTime,
  eventDetails,
  videoPlayer,
  videoUrl,
  videoDuration,
  videoPublicId,
  transformation,
  videoExtension,
  customerData,
  videoData,
  providedData,
  cloudName,
  publicId,
  type,
  version,
}

enum EventNames {
  viewStart('viewStart'),
  viewEnd('viewEnd'),
  loadMetadata('loadMetadata'),
  play('play'),
  pause('pause');

  final String value;
  const EventNames(this.value);
}
