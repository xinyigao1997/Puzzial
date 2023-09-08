import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/button_widget.dart';

/// A widget that displays a share button for copying the session ID.
///
/// This widget creates a button with an image and a transparent background.
/// When tapped, the button copies the session ID and download URL to the clipboard.
class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  /// Copies the session ID and download URL to the clipboard.
  ///
  /// This method uses [Clipboard.setData] to store a string containing
  /// the session ID and download URL, separated by 'SEP'.
  void copySessionId() async {
    await Clipboard.setData(ClipboardData(
        text:
            '${GameState.instance.sessionId}SEP${GameState.instance.downloadUrl}'));
  }

  /// Builds the widget tree for the share button.
  ///
  /// This method returns a [Container] widget with a transparent background.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 30,
      height: 30,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
              onTap: copySessionId, imageUrl: 'assets/images/copy.png'),
        ),
      ),
    );
  }
}
