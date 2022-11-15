import 'package:cloudinary_dart/asset/cld_image.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:flutter/widgets.dart';
import 'cloudinary_context.dart';

class CldImageWidget extends StatefulWidget {
  late final CldImage image;
  CldImageWidget(
      {required String publicId,
      super.key,
      String? version,
      String? extension,
      String? urlSuffix,
      String? assetType,
      String? deliveryType,
      Transformation? transformation}) {
    image = CloudinaryContext.cloudinary.image(publicId);
    ((version != null) ? image.version(version) : null);
    ((extension != null) ? image.extension(extension) : null);
    ((urlSuffix != null) ? image.urlSuffix(urlSuffix) : null);
    ((assetType != null) ? image.assetType(assetType) : null);
    ((deliveryType != null) ? image.deliveryType(deliveryType) : null);
    ((transformation != null) ? image.transformation(transformation) : null);
  }

  @override
  State<StatefulWidget> createState() {
    return _CldImageState();
  }
}

class _CldImageState extends State<CldImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(widget.image.toString());
  }
}
