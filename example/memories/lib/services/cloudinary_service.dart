import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  String? _cloudName;
  String? _uploadPreset;
  String? _apiKey;
  String? _apiSecret;
  bool _initialized = false;

  void initialize({
    required String cloudName,
    required String uploadPreset,
    String? apiKey,
    String? apiSecret,
  }) {
    _cloudName = cloudName;
    _uploadPreset = uploadPreset;
    _apiKey = apiKey;
    _apiSecret = apiSecret;
    _initialized = true;
  }

  Future<String?> uploadImage(
    File imageFile, {
    Function(double)? onProgress,
  }) async {
    if (!_initialized || _cloudName == null || _uploadPreset == null) {
      throw Exception('Cloudinary not initialized. Call initialize() first.');
    }

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = _uploadPreset!;
      request.fields['folder'] = 'memories';

      final file = await http.MultipartFile.fromPath('file', imageFile.path);

      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['secure_url'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    Function(int current, int total)? onProgress,
  }) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      if (onProgress != null) {
        onProgress(i + 1, imageFiles.length);
      }

      final url = await uploadImage(imageFiles[i]);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }

  Future<bool> deleteImage(String imageUrl) async {
    if (!_initialized || _cloudName == null) {
      throw Exception('Cloudinary not initialized. Call initialize() first.');
    }

    if (_apiKey == null || _apiSecret == null) {
      return false;
    }

    try {
      final publicId = getPublicIdFromUrl(imageUrl);
      if (publicId.isEmpty) return false;

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signature = _generateSignature(publicId, timestamp);

      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
      );

      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'timestamp': timestamp.toString(),
          'api_key': _apiKey!,
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['result'] == 'ok';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _generateSignature(String publicId, int timestamp) {
    final toSign = 'public_id=$publicId&timestamp=$timestamp$_apiSecret';
    final bytes = utf8.encode(toSign);
    final hash = sha1.convert(bytes);
    return hash.toString();
  }

  String getPublicIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        final publicIdWithExtension = pathSegments
            .sublist(uploadIndex + 2)
            .join('/');
        return publicIdWithExtension.split('.').first;
      }
    } catch (e) {
      debugPrint('Error extracting public ID: $e');
    }

    return '';
  }

  bool isCloudinaryUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  String getOptimizedUrl(
    String url, {
    int? width,
    int? height,
    String quality = 'auto',
  }) {
    if (!isCloudinaryUrl(url)) return url;

    try {
      final transformations = <String>[];

      if (width != null) transformations.add('w_$width');
      if (height != null) transformations.add('h_$height');
      transformations.add('q_$quality');
      transformations.add('f_auto');

      final uri = Uri.parse(url);
      final uploadIndex = uri.pathSegments.indexOf('upload');

      if (uploadIndex != -1) {
        final newSegments = List<String>.from(uri.pathSegments);
        newSegments.insert(uploadIndex + 1, transformations.join(','));

        return Uri(
          scheme: uri.scheme,
          host: uri.host,
          pathSegments: newSegments,
        ).toString();
      }
    } catch (e) {
      debugPrint('Error optimizing URL: $e');
    }

    return url;
  }
}
