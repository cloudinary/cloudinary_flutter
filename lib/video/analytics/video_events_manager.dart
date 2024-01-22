import 'dart:convert';
import 'package:cloudinary_flutter/video/analytics/video_analytics.dart';
import 'package:cloudinary_flutter/video/analytics/video_analytics_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class VideoEventsManager {
  final String CLD_ANALYTICS_ENDPOINT_PRODUCTION_URL =
      "https://video-analytics-api.cloudinary.com/v1/video-analytics";
  String CLD_ANALYTICS_ENDPOINT_DEVELOPMENT_URL =
      "http://localhost:3001/events";

  String viewId;
  late String userId;
  TrackingType trackingType;
  String? cloudName;
  String? publicId;

  List<VideoEvent> eventQueue = [];
  Timer? timer;

  VideoEventsManager({this.cloudName, this.publicId})
      : trackingType = TrackingType.auto,
        viewId = VideoAnalyticsHelper.generateUuid() {
    _getUserId();
  }

  void _getUserId() async {
    userId = await UserIdHelper.getUserId();
  }

  void sendViewStartEvent(String videoUrl,
      {Map<String, dynamic>? providedData}) {
    final event = VideoViewStartEvent(
      trackingType: trackingType,
      videoUrl: videoUrl,
      trackingData: {"cloudName": cloudName ?? "", "publicId": publicId ?? ""},
      providedData: providedData,
    );
    addEventToQueue(event);
  }

  void sendViewEndEvent({Map<String, dynamic>? providedData}) {
    final event = VideoViewEnd(
      trackingType: trackingType,
      providedData: providedData,
    );
    addEventToQueue(event);
  }

  void sendLoadMetadataEvent(int duration,
      {Map<String, dynamic>? providedData}) {
    final event = VideoLoadMetadata(
      trackingType: trackingType,
      duration: duration,
      providedData: providedData,
    );
    addEventToQueue(event);
  }

  void sendPlayEvent({Map<String, dynamic>? providedData}) {
    final event = VideoPlayEvent(
      trackingType: trackingType,
      providedData: providedData,
    );
    addEventToQueue(event);
  }

  void sendPauseEvent() {
    final event = VideoPauseEvent(
      trackingType: trackingType,
    );
    addEventToQueue(event);
  }

  void addEventToQueue(VideoEvent event) {
    eventQueue.add(event);
  }

  Future<void> sendEvents() async {
    if (eventQueue.isEmpty) {
      return;
    }

    final List<VideoEvent> eventsToSend = List.from(eventQueue);
    await sendEventToEndpoint(eventsToSend);
    eventQueue.removeRange(0, eventsToSend.length);
  }

  Future<void> sendEventToEndpoint(List<VideoEvent> childEvents) async {
    final uri = Uri.parse(CLD_ANALYTICS_ENDPOINT_PRODUCTION_URL);
    final request = http.MultipartRequest('POST', uri);

    final boundary = 'Boundary-${VideoAnalyticsHelper.generateUuid()}';
    request.headers['Content-Type'] = 'multipart/form-data; boundary=$boundary';
    request.headers['User-Agent'] = 'ios_video_player_analytics_test';

    // Add events data as a file
    final eventsFile = await buildEventsData(childEvents);
    request.files.add(eventsFile);

    // Add other fields if needed
    request.fields['userId'] = userId;
    request.fields['viewId'] = viewId;

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Event sent successfully');
    } else {
      print('Failed to send event. Response: ${response.body}');
    }
  }

  Future<http.MultipartFile> buildEventsData(
      List<VideoEvent> childEvents) async {
    final eventData = <Map<String, dynamic>>[];
    for (final childEvent in childEvents) {
      eventData.add({
        VideoEventJSONKeys.eventName.name: childEvent.eventName,
        VideoEventJSONKeys.eventTime.name: childEvent.eventTime,
        VideoEventJSONKeys.eventDetails.name: childEvent.eventDetails,
      });
    }

    final jsonData = json.encode(eventData);
    return http.MultipartFile.fromString('events', jsonData);
  }
}
