import 'package:flutter/material.dart';

/// A Flutter widget that displays a custom button with an image.
///
/// This widget is a stateless widget that takes an image URL and a callback function
/// to be executed when the button is tapped.
///
/// {@tool snippet}
///
/// Usage example:
///
/// ```dart
/// CustomButton(
///   onTap: () {
///     print('Button tapped');
///   },
///   imageUrl: 'assets/images/icon.png',
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [VoidCallback], the type of the onTap callback.
class CustomButton extends StatelessWidget {
  /// The callback function that is executed when the button is tapped.
  final VoidCallback onTap;

  /// The URL of the image to be displayed as the button icon.
  final String imageUrl;

  /// Creates a [CustomButton] widget.
  ///
  /// The [onTap] and [imageUrl] parameters must be non-null.
  /// The [key] parameter is optional and can be used for identifying
  /// this widget in the widget tree.
  const CustomButton({Key? key, required this.onTap, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IconButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey,
        ),
        onPressed: onTap,
        icon: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
