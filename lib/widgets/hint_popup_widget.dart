import 'dart:typed_data';
import 'package:flutter/material.dart';

/// A StatefulWidget that displays a hint image within a popup.
class HintPopUp extends StatefulWidget {
  /// The bytes of the image to be displayed within the popup.
  final Uint8List imageBytes;

  /// A [ValueNotifier] to manage the visibility of the popup.
  final ValueNotifier<bool> visible;

  /// Creates a new [HintPopUp] widget.
  ///
  /// The [imageBytes] and [visible] arguments must not be null.
  const HintPopUp({
    Key? key,
    required this.imageBytes,
    required this.visible,
  }) : super(key: key);

  @override
  HintPopUpState createState() => HintPopUpState();
}

/// The state for the [HintPopUp] widget.
///
/// This class manages the visibility of the popup and handles user interaction
/// to toggle the visibility.
class HintPopUpState extends State<HintPopUp> {
  /// Toggles the visibility of the popup.
  void _togglePopupVisibility() {
    widget.visible.value = !widget.visible.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.visible,
      builder: (context, visible, child) {
        return Visibility(
          visible: widget.visible.value,
          child: GestureDetector(
            onTap: _togglePopupVisibility,
            child: Container(
              color: Colors.grey.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(widget.imageBytes),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
