import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/video/analytics/video_analytics.dart';
import 'package:cloudinary_flutter/video/cld_video_controller.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({'user_id': '12345'});
  CloudinaryObject.cloudinary = Cloudinary.fromCloudName(
    cloudName: 'test_cloud',
  );
  CloudinaryObject.cloudinary.config.urlConfig.analytics = false;
  group('CldVideoController Tests', () {
    test('CldVideoController.networkUrl() sets correct URI', () {
      final Uri testUri = Uri.parse('https://example.com/video.mp4');
      final CldVideoController controller = CldVideoController.networkUrl(
        testUri,
      );
      controller.setAnalytics(AnalyticsType.disabled);
      expect(controller.uri, testUri);
    });

    test('CldVideoController constructor builds correct URI', () {
      final String publicId = 'sample_public_id';
      final String version = '12345';
      final String extension = 'mp4';
      final String assetType = 'video';
      final String deliveryType = 'upload';
      final Transformation transformation = Transformation().resize(
        Resize.crop()
          ..width(100)
          ..height(100),
      );
      final bool automaticStreamingProfile = true;

      final CldVideoController controller = CldVideoController(
        publicId: publicId,
        version: version,
        extension: extension,
        assetType: assetType,
        deliveryType: deliveryType,
        transformation: transformation,
        automaticStreamingProfile: automaticStreamingProfile,
      );

      final String expectedUriString =
          'https://res.cloudinary.com/test_cloud/video/upload/c_crop,h_100,w_100/v12345/sample_public_id.mp4';
      expect(controller.dataSource.toString(), expectedUriString);
    });

    test(
      'CldVideoController constructor builds correct URI with automatic streaming profile',
      () {
        final String publicId = 'sample_public_id';

        final CldVideoController controller = CldVideoController(
          publicId: publicId,
          automaticStreamingProfile: true,
        );

        final String expectedUriString =
            'https://res.cloudinary.com/test_cloud/video/upload/'
            'sp_auto/sample_public_id.m3u8';
        expect(controller.dataSource.toString(), expectedUriString);
      },
    );

    test(
      'CldVideoController constructor builds correct URI with custom transformation',
      () {
        final String publicId = 'sample_public_id';
        final Transformation transformation = Transformation().resize(
          Resize.crop().width(800).height(600),
        );

        final CldVideoController controller = CldVideoController(
          publicId: publicId,
          transformation: transformation,
        );

        final String expectedUriString =
            'https://res.cloudinary.com/test_cloud/video/upload/'
            'c_crop,h_600,w_800/sample_public_id';
        expect(controller.dataSource.toString(), expectedUriString);
      },
    );

    test(
      'CldVideoController constructor builds correct URI with specific cloudinary',
      () {
        Cloudinary cloudinary = CloudinaryObject.fromCloudName(
          cloudName: "test",
        );
        cloudinary.config.urlConfig.analytics = false;
        final String publicId = 'sample_public_id';

        final CldVideoController controller = CldVideoController(
          publicId: publicId,
          cloudinary: cloudinary,
        );

        final String expectedUriString =
            'https://res.cloudinary.com/test/video/upload/'
            'sample_public_id';
        expect(controller.dataSource.toString(), expectedUriString);
      },
    );

    test(
      'CldVideoController constructor builds correct URI with specific cloudinary and automatic streaming profile',
      () {
        Cloudinary cloudinary = CloudinaryObject.fromCloudName(
          cloudName: "test",
        );
        cloudinary.config.urlConfig.analytics = false;
        final String publicId = 'sample_public_id';

        final CldVideoController controller = CldVideoController(
          publicId: publicId,
          cloudinary: cloudinary,
          automaticStreamingProfile: true,
        );

        final String expectedUriString =
            'https://res.cloudinary.com/test/video/upload/sp_auto/'
            'sample_public_id.m3u8';
        expect(controller.dataSource.toString(), expectedUriString);
      },
    );
  });
}
