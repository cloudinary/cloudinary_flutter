import 'dart:io';

import 'package:cloudinary_url_gen/analytics.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

/// Helper class to help users define the Cloudinary object to be used with their widgets
class CloudinaryObject extends Cloudinary {
  CloudinaryObject.fromCloudName({required String cloudName})
      : super.fromCloudName(cloudName: cloudName) {
    var techVersion = Platform.version.split(" ")[0];
    Analytics analytics =
        Analytics.fromParameters('O', sdkVersion, techVersion, _getOsVersion());
    super.setAnalytics(analytics);
  }

  String _getOsVersion() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Platform.operatingSystemVersion;
    }
    return 'AA';
  }
}
