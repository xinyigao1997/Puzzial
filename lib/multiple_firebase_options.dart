import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class MultipleFirebaseOptions {
  static FirebaseOptions get loginAppOptions {
    if (kIsWeb) {
      return loginAppWeb;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return loginAppAndroid;
      case TargetPlatform.iOS:
        return loginAppIos;
      case TargetPlatform.macOS:
        return loginAppMacos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
      default:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get gameStateAppOptions {
    if (kIsWeb) {
      return gameStateAppWeb;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return gameStateAppAndroid;
      case TargetPlatform.iOS:
        return gameStateAppIos;
      case TargetPlatform.macOS:
        return gameStateAppMacos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
      default:
        throw UnsupportedError(
          'MultipleFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions loginAppWeb = FirebaseOptions(
    apiKey: 'AIzaSyBoDCN0U6OHqnlEYaapx8tj_fbyiks-H1w',
    appId: '1:198146297205:web:6f376f484de07bbed5973c',
    messagingSenderId: '198146297205',
    projectId: 'flutterfire-ui-codelab-deda7',
    authDomain: 'flutterfire-ui-codelab-deda7.firebaseapp.com',
    storageBucket: 'flutterfire-ui-codelab-deda7.appspot.com',
  );

  static const FirebaseOptions loginAppAndroid = FirebaseOptions(
    apiKey: 'AIzaSyC82FLFfxIssSNc3XflvEC5QQGEQ8AUv0I',
    appId: '1:198146297205:android:cc4301b24db7d976d5973c',
    messagingSenderId: '198146297205',
    projectId: 'flutterfire-ui-codelab-deda7',
    storageBucket: 'flutterfire-ui-codelab-deda7.appspot.com',
  );

  static const FirebaseOptions loginAppIos = FirebaseOptions(
    apiKey: 'AIzaSyBZoLRYLnRV8FfMje_I6tTbBxCivTCSfBQ',
    appId: '1:198146297205:ios:7c40b75f0bac56a7d5973c',
    messagingSenderId: '198146297205',
    projectId: 'flutterfire-ui-codelab-deda7',
    storageBucket: 'flutterfire-ui-codelab-deda7.appspot.com',
    iosClientId:
        '198146297205-t1umk29pgin64ccav9s5gnud6brpfhsl.apps.googleusercontent.com',
    iosBundleId: 'com.example.puzzial',
  );

  static const FirebaseOptions loginAppMacos = FirebaseOptions(
    apiKey: 'AIzaSyBZoLRYLnRV8FfMje_I6tTbBxCivTCSfBQ',
    appId: '1:198146297205:ios:7c40b75f0bac56a7d5973c',
    messagingSenderId: '198146297205',
    projectId: 'flutterfire-ui-codelab-deda7',
    storageBucket: 'flutterfire-ui-codelab-deda7.appspot.com',
    iosClientId:
        '198146297205-t1umk29pgin64ccav9s5gnud6brpfhsl.apps.googleusercontent.com',
    iosBundleId: 'com.example.puzzial',
  );

  static const FirebaseOptions gameStateAppWeb = FirebaseOptions(
    apiKey: 'AIzaSyDnud1eTRK4h025D-ZChhpKd06J8noIZyE',
    appId: '1:636587858000:web:e1530cd9e0f31afb035955',
    messagingSenderId: '636587858000',
    projectId: 'puzzial-young-justice',
    authDomain: 'puzzial-young-justice.firebaseapp.com',
    storageBucket: 'puzzial-young-justice.appspot.com',
  );

  static const FirebaseOptions gameStateAppAndroid = FirebaseOptions(
    apiKey: 'AIzaSyAmWE7GRscrzGOhDqat7AY1hO7uEFoPYEY',
    appId: '1:636587858000:android:f5fa66379f22776f035955',
    messagingSenderId: '636587858000',
    projectId: 'puzzial-young-justice',
    storageBucket: 'puzzial-young-justice.appspot.com',
  );

  static const FirebaseOptions gameStateAppIos = FirebaseOptions(
    apiKey: 'AIzaSyCICHzU1GeeNHao4Civ2y61d5Vy6-mCiN0',
    appId: '1:636587858000:ios:9a796d5bbfbb7823035955',
    messagingSenderId: '636587858000',
    projectId: 'puzzial-young-justice',
    storageBucket: 'puzzial-young-justice.appspot.com',
    iosClientId:
        '636587858000-jebiit5sfqp1hc4adr1au7coekvi21vu.apps.googleusercontent.com',
    iosBundleId: 'com.example.puzzial',
  );

  static const FirebaseOptions gameStateAppMacos = FirebaseOptions(
    apiKey: 'AIzaSyCICHzU1GeeNHao4Civ2y61d5Vy6-mCiN0',
    appId: '1:636587858000:ios:9a796d5bbfbb7823035955',
    messagingSenderId: '636587858000',
    projectId: 'puzzial-young-justice',
    storageBucket: 'puzzial-young-justice.appspot.com',
    iosClientId:
        '636587858000-jebiit5sfqp1hc4adr1au7coekvi21vu.apps.googleusercontent.com',
    iosBundleId: 'com.example.puzzial',
  );
}
