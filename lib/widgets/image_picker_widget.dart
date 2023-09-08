import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

/// A custom widget that allows the user to pick and crop an image.
class ImagePickerWidget extends StatefulWidget {
  /// The callback that is called when an image is selected and cropped.
  final Function(XFile) onImageSelected;

  /// Creates a new instance of [ImagePickerWidget].
  ///
  /// [onImageSelected] must not be null.
  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  /// Checks and requests camera and gallery permissions.
  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }
    final galleryStatus = await Permission.photos.status;
    if (galleryStatus.isDenied) {
      await Permission.photos.request();
    }
  }

  /// Picks an image from the [source] and calls the [_cropImage] method.
  Future<void> _pickImage(ImageSource source) async {
    await _checkPermissions();
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      await _cropImage(pickedFile);
    }
  }

  /// Shows a dialog to choose between the camera and the gallery for image selection.
  Future<void> _showImagePickerDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose puzzle image source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  /// Crops the [imageFile] and calls the [onImageSelected] callback.
  Future<void> _cropImage(XFile imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 2.4, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      widget.onImageSelected(XFile(croppedFile.path));
    }
  }

  /// Builds the [ImagePickerWidget].
  ///
  /// The widget contains an elevated button that triggers the image picker dialog.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showImagePickerDialog,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        minimumSize: const Size(150, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.deepPurple.shade700, width: 2),
        ),
        elevation: 5,
        shadowColor: Colors.deepPurple.shade300,
      ),
      child: const Text(
        'Select Puzzle Image',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
