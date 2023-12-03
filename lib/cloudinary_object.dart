import 'dart:io';

import 'package:cloudinary_url_gen/analytics.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

final sdkVersion = '1.1.0';

/// Helper class to help users define the Cloudinary object to be used with their widgets
class CloudinaryObject extends Cloudinary {
  CloudinaryObject.fromCloudName({required String cloudName})
      : super.fromCloudName(cloudName: cloudName) {
    var techVersion = Platform.version.split(" ")[0];
    Analytics analytics =
        Analytics.fromParameters('O', sdkVersion, techVersion, _getOsVersion());
    Cloudinary.userAgent = 'CloudinaryFlutter/$sdkVersion';
    super.setAnalytics(analytics);
  }

  String _getOsVersion() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Platform.operatingSystemVersion;
    }
    return 'AA';
  }
}
