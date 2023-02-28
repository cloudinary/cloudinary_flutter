import 'package:cloudinary_dart/asset/cld_image.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:flutter/widgets.dart';

import '../cloudinary_context.dart';

/// A widget that displays an image.
/// A constructor with multiple attributes provided for the various ways that an image can be
/// The widget is meant to display an image from the Cloudinary's cloud
/// The [publicId] field should not be null and must be provided.
class CldImageWidget extends Image {
  /// Cloudinary image object
  /// This object holds all of Cloudinary's attributes.
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
    if (version != null) {
      cldImage.version(version);
    }
    if (extension != null) {
      cldImage.extension(extension);
    }
    if (urlSuffix != null) {
      cldImage.urlSuffix(urlSuffix);
    }
    if (assetType != null) {
      cldImage.assetType(assetType);
    }
    if (deliveryType != null) {
      cldImage.deliveryType(deliveryType);
    }
    if (transformation != null) {
      cldImage.transformation(transformation);
    }
  }

  @override
  State<Image> createState() {
    return _CldImageState();
  }
}

class _CldImageState extends State<CldImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.cldImage.toString(),
      frameBuilder: widget.frameBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      semanticLabel: widget.semanticLabel,
      excludeFromSemantics: widget.excludeFromSemantics,
      width: widget.width,
      height: widget.height,
      color: widget.color,
      opacity: widget.opacity,
      colorBlendMode: widget.colorBlendMode,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      centerSlice: widget.centerSlice,
      matchTextDirection: widget.matchTextDirection,
      gaplessPlayback: widget.gaplessPlayback,
      isAntiAlias: widget.isAntiAlias,
      filterQuality: widget.filterQuality
    );
  }
}

/**
 * frameBuilder: frameBuilder,
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
    filterQuality: filterQuality
 */
