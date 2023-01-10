import 'dart:io';

import 'package:cloudinary_dart/cloudinary.dart';
import 'package:cloudinary_dart/transformation/resize/resize.dart';
import 'package:cloudinary_dart/transformation/transformation.dart';
import 'package:cloudinary_flutter/cld_video.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'demo');
  CloudinaryContext.cloudinary.config.urlConfig.analytics = false;
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('Test CldVideoWidget applies to view', (widgetTester) async {
    var widget = CldVideoWidget(publicId: 'dog');
    await widgetTester.pumpWidget(MaterialApp(home: Container(child: widget)));

    final widgetFinder = find.byWidget(widget);
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('Test CldVideoWidget applies to view with version has valid url',
      (widgetTester) async {
    var widget = CldVideoWidget(
      publicId: 'dog',
      version: "1",
    );
    await widgetTester.pumpWidget(MaterialApp(home: Container(child: widget)));
    final widgetFinder = find.byWidget(widget);
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('Test CldVideoWidget applies to view with version has valid url',
      (widgetTester) async {
    var widget = CldVideoWidget(
      publicId: 'dog',
      version: "1",
      urlSuffix: "test",
    );
    await widgetTester.pumpWidget(MaterialApp(home: Container(child: widget)));
    final widgetFinder = find.byWidget(widget);
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets(
      'Test CldVideoWidget applies to view with transformation has valid url',
      (widgetTester) async {
    var widget = CldVideoWidget(
      publicId: 'dog',
      version: "1",
      urlSuffix: "test",
      transformation: Transformation().resize(Resize.crop().width(500)),
    );
    await widgetTester.pumpWidget(MaterialApp(home: Container(child: widget)));
    final widgetFinder = find.byWidget(widget);
    expect(widgetFinder, findsOneWidget);
  });
}
