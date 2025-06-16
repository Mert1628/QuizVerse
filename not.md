name: QuizVerse
description: A new Flutter project.

publish_to: "none" # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.

  cupertino_icons: ^1.0.2
  font_awesome_flutter: ^10.8.0
  google_fonts: ^6.1.0
  html_unescape: ^2.0.0
  http: ^1.3.0
  googleapis: ^14.0.0
  googleapis_auth: ^1.3.0
  firebase_core: ^2.27.0
  firebase_auth: ^4.17.4
  firebase_auth_web: ^5.8.13
  cloud_firestore: ^4.15.4
  shared_preferences: ^2.0.17
  js: ^0.6.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/image/logo.png

flutter_icons:
  image_path: "assets/image/logo.png"
  android: "launcher_icon"
  ios: true
  min_sdk_android: 21 # android min sdk min:16, default 21
  web:
    generate: true
    image_path: "assets/image/logo.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: true
    image_path: "assets/image/logo.png"
    icon_size: 48 # min:48, max:256, default: 48
  macos:
    generate: true
    image_path: "assets/image/logo.png"
    