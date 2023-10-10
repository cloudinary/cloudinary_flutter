import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/video/cld_video_controller.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'test_cloud');
  CloudinaryContext.cloudinary.config.urlConfig.analytics = false;
  group('CldVideoController Tests', () {
    test('CldVideoController.networkUrl() sets correct URI', () {
      final Uri testUri = Uri.parse('https://example.com/video.mp4');
      final CldVideoController controller = CldVideoController.networkUrl(testUri);
      expect(controller.uri, testUri);
    });

    test('CldVideoController constructor builds correct URI', () {
      final String publicId = 'sample_public_id';
      final String version = '12345';
      final String extension = 'mp4';
      final String assetType = 'video';
      final String deliveryType = 'upload';
      final Transformation transformation = Transformation().resize(Resize.crop()..width(100)
        ..height(100));
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

      final String expectedUriString = 'https://res.cloudinary.com/test_cloud/video/upload/c_crop,h_100,w_100/v12345/sample_public_id.mp4';
      expect(controller.dataSource.toString(), expectedUriString);
    });

    test('CldVideoController constructor builds correct URI with automatic streaming profile', () {
      final String publicId = 'sample_public_id';

      final CldVideoController controller = CldVideoController(
        publicId: publicId,
        automaticStreamingProfile: true,
      );

      final String expectedUriString = 'https://res.cloudinary.com/test_cloud/video/upload/'
          'sp_auto/sample_public_id.m3u8';
      expect(controller.dataSource.toString(), expectedUriString);
    });

    test('CldVideoController constructor builds correct URI with custom transformation', () {
      final String publicId = 'sample_public_id';
      final Transformation transformation = Transformation().resize(Resize.crop().width(800).height(600));

      final CldVideoController controller = CldVideoController(
        publicId: publicId,
        transformation: transformation,
      );

      final String expectedUriString = 'https://res.cloudinary.com/test_cloud/video/upload/'
          'c_crop,h_600,w_800/sample_public_id';
      expect(controller.dataSource.toString(), expectedUriString);
    });
  });
}