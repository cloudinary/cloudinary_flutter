import 'package:cloudinary_flutter/video/analytics/video_analytics.dart';
import 'package:cloudinary_flutter/video/cld_video_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({'user_id': '12345'});
  group('CldVideoController Tests', () {
    late CldVideoController videoController;

    setUp(() {
      videoController = CldVideoController.networkUrl(Uri.parse(
          'https://res.cloudinary.com/test/video/upload/sea_turtle.mp4'));
    });

    test('Initialization Test', () {
      expect(
          videoController.uri,
          equals(Uri.parse(
              'https://res.cloudinary.com/test/video/upload/sea_turtle.mp4')));
      expect(videoController.eventsManager, isNotNull);
      expect(videoController.analytics, isTrue);
    });

    test('Set Analytics Test', () {
      SharedPreferences.setMockInitialValues({'user_id': '12345'});
      videoController.setAnalytics(AnalyticsType.manual,
          cloudName: 'test_cloud_name', publicId: 'test_public_id');

      expect(videoController.eventsManager.trackingType,
          equals(TrackingType.manual));
      expect(
          videoController.eventsManager.cloudName, equals('test_cloud_name'));
      expect(videoController.eventsManager.publicId, equals('test_public_id'));
    });
  });
}
