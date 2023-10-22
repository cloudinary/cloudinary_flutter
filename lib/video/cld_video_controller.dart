import 'package:cloudinary_url_gen/asset/cld_video.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/video_edit/transcode/transcode.dart';
import 'package:cloudinary_url_gen/transformation/video_edit/transcode/transcode_actions.dart';
import 'package:video_player/video_player.dart';
import '../cloudinary_context.dart';

class CldVideoController extends VideoPlayerController {
  late final Uri uri;

  CldVideoController.networkUrl(Uri url) : super.networkUrl(url) {
    uri = url;
  }

  CldVideoController({
    required String publicId,
    Cloudinary? cloudinary,
    String? version,
    String? extension,
    String? urlSuffix,
    String? assetType,
    String? deliveryType,
    Transformation? transformation,
    bool? automaticStreamingProfile,
  }) : super.networkUrl(_buildVideoUri(
            publicId,
            cloudinary,
            version,
            extension,
            urlSuffix,
            assetType,
            deliveryType,
            transformation,
            automaticStreamingProfile));

  static Uri _buildVideoUri(
    String publicId,
    Cloudinary? cloudinary,
    String? version,
    String? extension,
    String? urlSuffix,
    String? assetType,
    String? deliveryType,
    Transformation? transformation,
    bool? automaticStreamingProfile,
  ) {
    cloudinary ??= CloudinaryContext.cloudinary;
    CldVideo video = cloudinary.video(publicId);
    ((version != null) ? video.version(version) : null);
    ((extension != null) ? video.extension(extension) : null);
    ((urlSuffix != null) ? video.urlSuffix(urlSuffix) : null);
    ((assetType != null) ? video.assetType(assetType) : null);
    ((deliveryType != null) ? video.deliveryType(deliveryType) : null);

    if ((automaticStreamingProfile == null || automaticStreamingProfile) &&
        transformation == null) {
      video.transformation(Transformation()
          .transcode(Transcode.streamingProfile(StreamingProfile.auto())));
      video.extension('m3u8');
    } else {
      ((transformation != null) ? video.transformation(transformation) : null);
    }
    return Uri.parse(video.toString());
  }
}
