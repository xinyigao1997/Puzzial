import 'package:flutter/material.dart';

/// A Flutter widget that displays an avatar image with the specified size and border radius.
///
/// This widget is a stateless widget that takes an image URL and displays it
/// with the given size and border radius.
///
/// {@tool snippet}
///
/// Usage example:
///
/// ```dart
/// Avatar(
///   imageUrl: 'https://example.com/image.jpg',
///   size: 40.0,
///   borderRadius: BorderRadius.circular(5),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [BorderRadius], which is used to define the border radius of the avatar image.
class Avatar extends StatelessWidget {
  /// The URL of the image to be displayed as the avatar.
  final String imageUrl;

  /// The size of the avatar image.
  ///
  /// This value is used for both width and height.
  final double size;

  /// The border radius of the avatar image.
  final BorderRadius borderRadius;

  /// Creates an [Avatar] widget.
  ///
  /// The [imageUrl], [size], and [borderRadius] parameters must be non-null.
  /// The [key] parameter is optional and can be used for identifying
  /// this widget in the widget tree.
  const Avatar({
    Key? key,
    required this.imageUrl,
    required this.size,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
