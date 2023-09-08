import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:puzzial/state/game_state.dart';

import 'mock.mocks.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}

class MockGameStateFactory implements GameStateFactory {
  @override
  Future<GameState> create() async {
    // Here, you can create a mocked GameState instance with your custom implementation
    DatabaseReference database = MockDatabaseReference();
    FirebaseStorage storage = MockFirebaseStorage();
    FirebaseApp app = MockFirebaseApp();

    return GameState.internal(database: database, storage: storage, app: app);
  }
}

Future<XFile> uint8ListToXFile(Uint8List data) async {
  // Get the temporary directory of the device
  PathProviderPlatform.instance = FakePathProviderPlatform();
  String? tempPath = await PathProviderPlatform.instance.getTemporaryPath();
  // Directory tempDir = Directory(tempPath!);

  // Create a temporary file with a unique name
  File file = await File(
          '$tempPath/temp_image_${DateTime.now().millisecondsSinceEpoch}.png')
      .create();

  // Write the Uint8List data to the temporary file
  await file.writeAsBytes(data);

  // Create an XFile instance from the temporary file
  XFile xfile = XFile(file.path);
  return xfile;
}
