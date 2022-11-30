import 'package:cloudinary_dart/asset/cld_image.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:flutter/widgets.dart';
import 'cloudinary_context.dart';

class CldImageWidget extends Image {
  late final CldImage cldImage;

  CldImageWidget(
      {required String publicId,
      super.key,
      String? version,
      String? extension,
      String? urlSuffix,
      String? assetType,
      String? deliveryType,
      Transformation? transformation,
      ImageFrameBuilder? frameBuilder,
      ImageLoadingBuilder? loadingBuilder,
      ImageErrorWidgetBuilder? errorBuilder,
      String? semanticLabel,
      bool excludeFromSemantics = false,
      double? width,
      double? height,
      Color? color,
      Animation<double>? opacity,
      BlendMode? colorBlendMode,
      BoxFit? fit,
      AlignmentGeometry alignment = Alignment.center,
      ImageRepeat repeat = ImageRepeat.noRepeat,
      Rect? centerSlice,
      bool matchTextDirection = false,
      bool gaplessPlayback = false,
      bool isAntiAlias = false,
      FilterQuality filterQuality = FilterQuality.low})
      : super(
            image: NetworkImage(''),
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            width: width,
            height: height,
            color: color,
            opacity: opacity,
            colorBlendMode: colorBlendMode,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            centerSlice: centerSlice,
            matchTextDirection: matchTextDirection,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            filterQuality: filterQuality) {
    cldImage = CloudinaryContext.cloudinary.image(publicId);
    ((version != null) ? cldImage.version(version) : null);
    ((extension != null) ? cldImage.extension(extension) : null);
    ((urlSuffix != null) ? cldImage.urlSuffix(urlSuffix) : null);
    ((assetType != null) ? cldImage.assetType(assetType) : null);
    ((deliveryType != null) ? cldImage.deliveryType(deliveryType) : null);
    ((transformation != null) ? cldImage.transformation(transformation) : null);
  }

  @override
  State<Image> createState() {
    return _CldImageState();
  }
}

class _CldImageState extends State<CldImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(widget.cldImage.toString());
  }
}
