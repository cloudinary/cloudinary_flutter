import 'package:cloudinary_dart/cloudinary.dart';
import 'package:cloudinary_dart/transformation/delivery/delivery.dart';
import 'package:cloudinary_dart/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
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
  });
}
