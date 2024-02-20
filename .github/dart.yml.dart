name: Flutter CI-CD

on:
  push:
    branches: [ "main","dev" ]
  pull_request:
    branches: [ "main","dev"  ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          # flutter-version: '3.16.x'
          channel: "stable"

      - name: Install dependencies
        run: dart pub get

      # Uncomment this step to verify the use of 'dart format' on each commit.
      # - name: Verify formatting
      #   run: dart format --output=none --set-exit-if-changed .

      # Consider passing '--fatal-infos' for slightly stricter analysis.
      # - name: Analyze project source
      #   run: dart analyze

      # Your project will need to have tests in test/ and a dependency on
      # package:test for this step to succeed. Note that Flutter projects will
      # want to change this to 'flutter test'.
      # - name: Run tests
      #   run: dart test

      - name: Generate constants file
        run: |
          echo "class ApiConstants {" >> lib/data/constants/constants.dart
          if [[ $GITHUB_REF == refs/heads/main ]]; then
            echo "static const String baseAuthUrl = 'https://dev.auth.seymo.ai';" >> lib/data/constants/constants.dart
          else
            echo "static const String baseAuthUrl = 'https://dev.auth.seymo.ai';" >> lib/data/constants/constants.dart
          fi
          echo "}" >> lib/data/constants/constants.dart

      - name: Build APK
        run: flutter build apk --release

      - name: Get app version
        run: |
          APP_VERSION=$(grep -oP 'version: \K(.+)' pubspec.yaml)
          echo "App Version: $APP_VERSION"

      - name: Rename APK
        run: mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/seymo_v$APP_VERSION.apk

      - name: Upload APK
        uses: actions/upload-artifact@v2
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/seymo.apk