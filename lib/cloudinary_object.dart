import 'package:cloudinary_url_gen/analytics/analytics.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

final sdkVersion = '1.3.0';

/// Helper class to help users define the Cloudinary object to be used with their widgets
class CloudinaryObject extends Cloudinary {
  static Cloudinary cloudinary = Cloudinary();

  CloudinaryObject.fromCloudName({required String cloudName})
    : super.fromCloudName(cloudName: cloudName) {
    Cloudinary.userAgent = 'CloudinaryFlutter/$sdkVersion';
    Analytics analytics = Analytics.fromParameters(
      sdk: 'O',
      version: sdkVersion,
    );
    super.setAnalytics(analytics);
  }
}
