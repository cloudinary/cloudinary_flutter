import 'package:cloudinary_flutter/video/analytics/video_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  SharedPreferences.setMockInitialValues({'user_id': '12345'});
  group('VideoEvent Tests', () {
    test('VideoViewStartEvent', () {
      final event = VideoViewStartEvent(
        videoUrl: 'https://example.com/video.mp4',
        trackingData: {'cloudName': 'cloud', 'publicId': 'public'},
        providedData: {'key': 'value'},
      );

      expect(event.eventName, 'viewStart');
      expect(event.eventDetails['videoUrl'], 'https://example.com/video.mp4');
      expect(event.eventDetails['customerData']['videoData']['cloudName'],
          'cloud');
      expect(event.eventDetails['customerData']['videoData']['publicId'],
          'public');
      expect(
          event.eventDetails['customerData']['providedData']['key'], 'value');
    });

    test('VideoLoadMetadata', () {
      final event = VideoLoadMetadata(
        duration: 120,
      );

      expect(event.eventName, 'loadMetadata');
      expect(event.eventDetails['videoDuration'], 120);
    });

    test('VideoViewEnd', () {
      final event = VideoViewEnd();

      expect(event.eventName, 'viewEnd');
    });

    test('VideoPlayEvent', () {
      final event = VideoPlayEvent();

      expect(event.eventName, 'play');
    });

    test('VideoPauseEvent', () {
      final event = VideoPauseEvent();

      expect(event.eventName, 'pause');
    });
  });

  group('Other Tests', () {
    test('TrackingType Enums', () {
      expect(TrackingType.auto.value, 'auto');
      expect(TrackingType.manual.value, 'manual');
    });

    test('EventNames Enums', () {
      expect(EventNames.viewStart.value, 'viewStart');
      expect(EventNames.viewEnd.value, 'viewEnd');
      expect(EventNames.loadMetadata.value, 'loadMetadata');
      expect(EventNames.play.value, 'play');
      expect(EventNames.pause.value, 'pause');
    });
  });
}
