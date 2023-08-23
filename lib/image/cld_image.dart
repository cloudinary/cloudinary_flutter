import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_url_gen/asset/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_flutter/image/no_disk_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../cloudinary_context.dart';
import 'cld_image_widget_configuration.dart';

/// A widget that displays a Cloudinary-hosted image. Its constructor offers various attributes to customize image presentation.
/// Ensure the [publicId] field is not null. It’s a required identifier for the image you want to display.
class CldImageWidget extends CachedNetworkImage {
  /// Cloudinary image object
  late final CldImage cldImage;
  final CldImageWidgetConfiguration? configuration;

  CldImageWidget(
      {required String publicId,
      super.key,
      this.configuration,
      String? version,
      String? extension,
      String? urlSuffix,
      String? assetType,
      String? deliveryType,
      Transformation? transformation,
      Map<String, String>? httpHeaders,
      ImageWidgetBuilder? imageBuilder,
      PlaceholderWidgetBuilder? placeholder,
      LoadingErrorWidgetBuilder? errorBuilder,
      Duration? placeholderFadeInDuration,
      int? memCacheWidth,
      int? memCacheHeight,
      String? cacheKey,
      int? maxWidthDiskCache,
      int? maxHeightDiskCache,
      double? width,
      double? height,
      Color? color,
      BlendMode? colorBlendMode,
      BoxFit? fit,
      ImageRepeat repeat = ImageRepeat.noRepeat,
      FilterQuality filterQuality = FilterQuality.low,
      bool matchTextDirection = false})
      : super(
            imageUrl: '',
            httpHeaders: httpHeaders,
            imageBuilder: imageBuilder,
            placeholder: placeholder,
            errorWidget: errorBuilder,
            width: width,
            height: height,
            color: color,
            filterQuality: filterQuality,
            colorBlendMode: colorBlendMode,
            placeholderFadeInDuration: placeholderFadeInDuration,
            memCacheWidth: memCacheWidth,
            memCacheHeight: memCacheHeight,
            cacheKey: cacheKey,
            maxWidthDiskCache: maxWidthDiskCache,
            maxHeightDiskCache: maxHeightDiskCache,
            fit: fit,
            repeat: repeat,
            matchTextDirection: matchTextDirection) {
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
  Widget build(BuildContext context) {
    var cacheManager = (configuration != null && !configuration!.cache)
        ? NoDiskCacheManager.instance
        : DefaultCacheManager();
    return CachedNetworkImage(
        imageUrl: cldImage.toString(),
        cacheManager: cacheManager,
        httpHeaders: super.httpHeaders,
        imageBuilder: super.imageBuilder,
        placeholder: super.placeholder,
        errorWidget: super.errorWidget,
        width: super.width,
        height: super.height,
        color: super.color,
        filterQuality: super.filterQuality,
        colorBlendMode: super.colorBlendMode,
        placeholderFadeInDuration: super.placeholderFadeInDuration,
        memCacheWidth: super.memCacheWidth,
        memCacheHeight: super.memCacheHeight,
        cacheKey: super.cacheKey,
        maxWidthDiskCache: super.maxWidthDiskCache,
        maxHeightDiskCache: super.maxHeightDiskCache,
        fit: super.fit,
        repeat: super.repeat,
        matchTextDirection: super.matchTextDirection);
  }
}
