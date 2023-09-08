@GenerateNiceMocks([MockSpec<File>()])
import 'dart:io';
@GenerateNiceMocks([MockSpec<ui.Image>()])
import 'dart:ui' as ui;
@GenerateNiceMocks([MockSpec<NetworkImage>()])
import 'package:flutter/painting.dart';
// import 'package:flutter/material.dart';
@GenerateNiceMocks([MockSpec<Clipboard>()])
import 'package:flutter/services.dart';
import 'package:mockito/annotations.dart';
@GenerateNiceMocks([MockSpec<GameState>()])
import 'package:puzzial/state/game_state.dart';
@GenerateNiceMocks([MockSpec<FirebaseApp>()])
import 'package:firebase_core/firebase_core.dart';
@GenerateNiceMocks([MockSpec<DatabaseReference>(), MockSpec<DataSnapshot>()])
import 'package:firebase_database/firebase_database.dart';
@GenerateNiceMocks([
  MockSpec<FirebaseStorage>(),
  MockSpec<Reference>(),
  MockSpec<TaskSnapshot>()
])
import 'package:firebase_storage/firebase_storage.dart';

void main() {}
