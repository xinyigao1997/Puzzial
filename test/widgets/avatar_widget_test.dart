import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:puzzial/widgets/avatar_widget.dart';

void main() {
  testWidgets('Avatar displays image with given size and border radius',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      const imageUrl = 'https://example.com/image.jpg';
      const size = 40.0;
      const borderRadius = BorderRadius.all(Radius.circular(5));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Avatar(
              imageUrl: imageUrl,
              size: size,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final avatar = tester.widget<Container>(find.byType(Container));
      final decoration = avatar.decoration as BoxDecoration;
      final decorationImage = decoration.image as DecorationImage;
      final networkImage = decorationImage.image as NetworkImage;

      expect(networkImage.url, imageUrl);
      expect(avatar.constraints!.maxWidth, size);
      expect(avatar.constraints!.maxHeight, size);
      expect(decoration.borderRadius, borderRadius);
    });
  });
}
