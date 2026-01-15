import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw
        UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyDO8cOy9ki6kjHuZ7eGpvt__QcOrR6Frjo',
  //   appId: '1:629263817932:android:b17625792492c1793cb669',
  //   messagingSenderId: '629263817932',
  //   projectId: 'rajveer-online-services-dcd7e',
  //   storageBucket: 'rajveer-online-services-dcd7e.firebasestorage.app',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDO8cOy9ki6kjHuZ7eGpvt__QcOrR6Frjo',
    appId:  '1:629263817932:android:b17625792492c1793cb669',
    messagingSenderId: '629263817932',
    projectId:    'rajveer-online-services-dcd7e',
    storageBucket:  'rajveer-online-services-dcd7e.firebasestorage.app',
  );


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-storage-bucket',
    iosBundleId: 'your-ios-bundle-id',
  );

}



