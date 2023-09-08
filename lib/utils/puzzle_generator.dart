/// A set of utility functions for splitting an image into smaller parts for creating puzzle games.
///
/// This module provides functions to split an image into smaller parts based on the number of rows and columns specified, and convert the cropped image parts to [ui.Image] objects for display.
///
import 'package:image/image.dart' as img;
import 'package:tuple/tuple.dart';
import 'package:puzzial/state/game_state.dart';
import 'dart:ui' as ui;

/// Splits an [ui.Image] into smaller parts based on the given number of rows and columns.
///
/// The function returns a list of [ui.Image] objects that can be used to display
/// the puzzle pieces. It also updates the relevant parameters in the [GameState]
/// object.
/// The [image] argument is the input [ui.Image] object that needs to be
/// split. The [rows] and [cols] arguments are the number of rows and columns
/// the image needs to be split into respectively.
Future<List<ui.Image>> splitImage(ui.Image uiImage, int rows, int cols) async {
  final image = await _convertUiImageToImage(uiImage);
  _setGameStateParameters(image, rows, cols);
  List<img.Image> parts = _cropImageParts(image, rows, cols);
  return _convertImagePartsToUiImages(parts);
}

/// Converts an [ui.Image] to [img.Image].
///
/// This function takes an [ui.Image] object and converts it to [img.Image] object. It uses the [uiImage.toByteData] method to get the byte data of the [ui.Image] object, and then uses the [img.Image.fromBytes] constructor to create an [img.Image] object from the byte data.
///
/// The [width], [height], and [numChannels] parameters are set based on the properties of the [ui.Image] object.
///
/// Throws an error if the conversion process fails.
///
Future<img.Image> _convertUiImageToImage(ui.Image uiImage) async {
  final uiBytes = await uiImage.toByteData();
  return img.Image.fromBytes(
    width: uiImage.width,
    height: uiImage.height,
    bytes: uiBytes!.buffer,
    numChannels: 4,
  );
}

/// Sets the parameters of the game state based on the provided image, rows, and columns.
///
/// This function calculates and sets the following parameters of the game state:
/// - puzzleHeight: The height of the puzzle, calculated by scaling the image's height proportionally
/// to the puzzleWidth based on the image's width.
/// - pieceWidth: The width of each puzzle piece, calculated by dividing the puzzleWidth by the number of columns.
/// - pieceHeight: The height of each puzzle piece, calculated by dividing the puzzleHeight by the number of rows.
/// - rows: The number of rows in the puzzle, set to the provided rows parameter.
/// - cols: The number of columns in the puzzle, set to the provided cols parameter.
/// - components: The total number of puzzle pieces, calculated by multiplying rows and cols.
///
/// Parameters:
/// - image: The image to use for calculating the puzzle parameters.
/// - rows: The number of rows in the puzzle.
/// - cols: The number of columns in the puzzle.
///
/// Note: This function assumes that the GameState class has an instance variable puzzleWidth which represents
/// the width of the puzzle and is accessible via GameState.instance.puzzleWidth.
void _setGameStateParameters(img.Image image, int rows, int cols) {
  final GameState state = GameState.instance;
  state.puzzleHeight = state.puzzleWidth / image.width * image.height;
  int gridWidth = state.puzzleWidth ~/ cols;
  int gridHeight = state.puzzleHeight ~/ rows;
  state.pieceWidth = gridWidth;
  state.pieceHeight = gridHeight;
  state.rows = rows;
  state.cols = cols;
  state.components = rows * cols;
}

/// Crops the provided image into parts based on the number of rows and columns, and returns a list of cropped images.
///
/// This function crops the input image into rows x cols number of parts, each having a width equal to the image's
/// width divided by cols, and a height equal to the image's height divided by rows. The cropped images are added to
/// a list parts, and the corresponding grid positions are calculated and added to the gridPositions list of the
/// GameState instance.
///
/// Parameters:
/// - image: The image to crop.
/// - rows: The number of rows to divide the image into.
/// - cols: The number of columns to divide the image into.
///
/// Returns:
/// A list of cropped images.
List<img.Image> _cropImageParts(img.Image image, int rows, int cols) {
  final GameState state = GameState.instance;
  List<img.Image> parts = [];
  int width = image.width ~/ cols;
  int height = image.height ~/ rows;
  int gridWidth = state.puzzleWidth ~/ cols;
  int gridHeight = state.puzzleHeight ~/ rows;
  const int offset = 30;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      parts.add(img.copyCrop(image,
          x: j * width, y: i * height, width: width, height: height));
      state.gridPositions.add(
          Tuple2<int, int>(j * gridWidth + offset, i * gridHeight + offset));
    }
  }
  return parts;
}

/// Converts a list of img.Image objects to a list of ui.Image objects asynchronously.
///
/// This function takes a list of img.Image objects as input, and converts each img.Image object to a ui.Image
/// object using the dart:ui library. The conversion is done asynchronously using await and async keywords, as
/// it involves decoding and encoding image data. The converted ui.Image objects are then added to a list outputs,
/// which is returned as the result.
///
/// Parameters:
/// - parts: The list of img.Image objects to convert.
///
/// Returns:
/// A list of ui.Image objects.
Future<List<ui.Image>> _convertImagePartsToUiImages(
    List<img.Image> parts) async {
  List<ui.Image> outputs = [];
  for (int i = 0; i < parts.length; i++) {
    ui.ImmutableBuffer buffer =
        await ui.ImmutableBuffer.fromUint8List(parts[i].toUint8List());
    ui.ImageDescriptor id = ui.ImageDescriptor.raw(buffer,
        height: parts[i].height,
        width: parts[i].width,
        pixelFormat: ui.PixelFormat.rgba8888);
    ui.Codec codec = await id.instantiateCodec(
      targetHeight: parts[i].height,
      targetWidth: parts[i].width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image outputImage = fi.image;
    outputs.add(outputImage);
  }
  return outputs;
}
