import 'dart:io';

import 'package:cloudinary_dart/cloudinary.dart';
import 'package:cloudinary_flutter/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.withStringUrl(
      'cloudinary://<API_KEY>:<API_SECRET>@demo?analytics=false');
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('Test CldImageWidget has valid image', (widgetTester) async {
    await widgetTester.pumpWidget(CldImageWidget('sample'));

    final imageFinder = find.image(
        NetworkImage('https://res.cloudinary.com/demo/image/upload/sample'));
    expect(imageFinder, findsOneWidget);
  });
}
