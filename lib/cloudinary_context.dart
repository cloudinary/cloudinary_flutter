import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

@Deprecated('Please use CloudinaryObject instead')
/// Helper class to help users define the Cloudinary object to be used with their [CldImageWidget]
class CloudinaryContext {
  static Cloudinary cloudinary = Cloudinary();
}
