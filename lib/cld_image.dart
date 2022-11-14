import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:flutter/widgets.dart';
import 'cloudinary_context.dart';

class CldImage extends StatefulWidget {
  final String publicId;
  final Transformation? transformation;
  const CldImage(this.publicId, {super.key, this.transformation});

  @override
  State<StatefulWidget> createState() {
    return _CldImageState();
  }
}

class _CldImageState extends State<CldImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network((CloudinaryContext.cloudinary.image(widget.publicId)
          ..transformation(widget.transformation ?? Transformation()))
        .toString());
  }
}
