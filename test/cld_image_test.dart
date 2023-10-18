import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/image/cld_image_widget_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CloudinaryObject cloudinary =
      CloudinaryObject.fromCloudName(cloudName: 'demo');
  cloudinary.config.urlConfig.analytics = false;
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Test CldImageWidget has valid url', (widgetTester) async {
    var widget = CldImageWidget(
        cloudinary: cloudinary, publicId: 'dog', width: 500, height: 100);
    await widgetTester.pumpWidget(widget);

    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/dog'));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Test CldImageWidget with version has valid url',
      (widgetTester) async {
    await widgetTester.pumpWidget(CldImageWidget(
      cloudinary: cloudinary,
      publicId: ('sample'),
      version: "1",
    ));
    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/v1/sample'));
    expect(imageFinder, findsOneWidget);
  });
  testWidgets('Test CldImageWidget with version and urlsuffix has valid url',
      (widgetTester) async {
    await widgetTester.pumpWidget(CldImageWidget(
      cloudinary: cloudinary,
      publicId: ('sample'),
      version: "1",
      urlSuffix: 'test',
    ));
    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/images/v1/sample/test'));
    expect(imageFinder, findsOneWidget);
  });
  testWidgets(
      'Test CldImageWidget with version and transformation has valid url',
      (widgetTester) async {
    await widgetTester.pumpWidget(CldImageWidget(
      cloudinary: cloudinary,
      publicId: ('sample'),
      version: "1",
      urlSuffix: 'test',
      transformation: Transformation()..resize(Resize.scale()..width(500)),
    ));
    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/images/c_scale,w_500/v1/sample/test'));
    expect(imageFinder, findsOneWidget);
  });
  testWidgets('Test CldImageWidget without cache', (widgetTester) async {
    var widget = CldImageWidget(
        cloudinary: cloudinary,
        publicId: 'dog',
        configuration: CldImageWidgetConfiguration(cache: false),
        width: 500,
        height: 100);
    await widgetTester.pumpWidget(widget);

    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/dog'));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Test CldImageWidget has valid url with analytics',
      (widgetTester) async {
    cloudinary.config.urlConfig.analytics = true;
    var widget = CldImageWidget(
        cloudinary: cloudinary, publicId: 'dog', width: 500, height: 100);
    await widgetTester.pumpWidget(widget);

    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/dog?_a=CAOAABBnZAA0'));
    expect(imageFinder, findsOneWidget);
  });
}
