import 'package:flutter/material.dart';
import 'package:puzzial/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzial/screens/game_screen.dart';
import 'package:puzzial/state/game_state.dart';

/// A screen for selecting an image for the puzzle game.
///
/// This screen displays a background image and an [ImagePickerWidget] for selecting an image.
/// After an image is selected, the user is taken to the [GamePage] where they can play the game.
/// The [GameState] instance is used to store the state of the game, including the puzzle pieces and grid positions.
class PictureSelectorPage extends StatefulWidget {
  /// A notifier for determining whether the image should be cut into pieces or not.
  final isCutting = ValueNotifier(true);

  /// Creates a new [PictureSelectorPage] instance.
  ///
  /// [key] is an optional [Key] for this widget.
  PictureSelectorPage({super.key});

  @override
  State<PictureSelectorPage> createState() => _PictureSelectorPageState();
}

/// Sets the puzzle image and generates the puzzle pieces.
///
/// [image] is the image to use for the puzzle.
Future<void> _setPuzzle(XFile image) async {
  final GameState state = GameState.instance;
  state.puzzleImage = image;
  await GameState.instance.saveImageToStorage();
  state.pieces = await GameState.instance.generatePuzzle();
}

/// A state for the [PictureSelectorPage].
class _PictureSelectorPageState extends State<PictureSelectorPage> {
  /// Callback function called when an image is selected.
  ///
  /// [image] is the selected image.
  void _onImageSelected(XFile image) async {
    final GameState state = GameState.instance;
    state.sessionId ??= state.players[0].playerId;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamgePage(isCutting: widget.isCutting),
      ),
    );
    state.hintImageBytes = await image.readAsBytes();
    state.gridPositions = [];
    await _setPuzzle(image);
    state.saveState(state.sessionId!);
    widget.isCutting.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              ///background image
              image: DecorationImage(
                image: AssetImage('assets/images/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// button that prompts user image selection
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Semantics(
                      label: "click to select a picture from your phone",
                      child:
                          ImagePickerWidget(onImageSelected: _onImageSelected)),
                ),

                ///button that navigates user back to home page / main menu
                Padding(
                  padding: const EdgeInsets.only(top: 140, left: 30),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Semantics(
                      label: "click to return to home page",
                      child: ElevatedButton.icon(
                        label: const Text(
                          'Home Page',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black.withOpacity(0.8), // Background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: Colors.deepPurple.shade700,
                              width: 2,
                            ),
                          ),
                          elevation: 5, // Shadow elevation
                          shadowColor:
                              Colors.deepPurple.shade300, // Shadow color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
