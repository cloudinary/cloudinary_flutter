import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_dart/cloudinary.dart';
import 'package:cloudinary_dart/transformation/resize/resize.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/image/cld_image_widget_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'demo');
  CloudinaryContext.cloudinary.config.urlConfig.analytics = false;
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Test CldImageWidget has valid url', (widgetTester) async {
    var widget = CldImageWidget(publicId: 'dog', width: 500, height: 100);
    await widgetTester.pumpWidget(widget);

    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/dog'));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Test CldImageWidget with version has valid url',
      (widgetTester) async {
    await widgetTester.pumpWidget(CldImageWidget(
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
        publicId: 'dog',
        configuration: CldImageWidgetConfiguration(cache: false),
        width: 500,
        height: 100);
    await widgetTester.pumpWidget(widget);

    final imageFinder = find.image(CachedNetworkImageProvider(
        'https://res.cloudinary.com/demo/image/upload/dog'));
    expect(imageFinder, findsOneWidget);
  });
}
