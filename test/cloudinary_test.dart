import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Cloud Config Tests', () {
    test('Should successfully initializes Cloudinary object using valid url',
        () {
      Cloudinary cloudinary = Cloudinary.fromStringUrl(
          "cloudinary://123456123456123:3Sf3FAdasa2easdFGDS3afADFS2@cloudname?shorten=true&cname=custom.domain.com");
      assert("cloudname" == cloudinary.config.cloudConfig.cloudName);
      assert("123456123456123" == cloudinary.config.cloudConfig.apiKey);
      assert("3Sf3FAdasa2easdFGDS3afADFS2" ==
          cloudinary.config.cloudConfig.apiSecret);
    });

    test('Should succesfully set user agent', () {
      CloudinaryObject.fromCloudName(cloudName: "test");
      assert(Cloudinary.userAgent.contains('CloudinaryFlutter'));
    });
  });
}
