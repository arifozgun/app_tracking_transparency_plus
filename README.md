# App Tracking Transparency Plus

A Flutter plugin for displaying the iOS 14+ App Tracking Transparency authorization dialog and requesting permission to collect user data. Essential for ad networks like AdMob to function efficiently on iOS 14+ devices.

Supports **Swift Package Manager** and CocoaPods.

## Features

- **iOS 14.0+ Support** — Presents the native app-tracking authorization request dialog.
- **Swift Package Manager** — Modern dependency management support for iOS.
- **CocoaPods** — Compatibility for projects that have not migrated to Swift Package Manager yet.
- **IDFA Access** — Retrieve the advertising identifier after user authorization.
- **Authorization Status** — Check current tracking authorization status before requesting.
- **AdMob Ready** — Designed to work seamlessly with Google Mobile Ads SDK.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  app_tracking_transparency_plus: ^<latest_version>
```

### Swift Package Manager

This plugin supports **Swift Package Manager** and CocoaPods. Flutter will use the dependency manager configured for your iOS project.

## Usage

### Step 1: Update Info.plist

Add the `NSUserTrackingUsageDescription` key to your `ios/Runner/Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

### Step 2: Configure SKAdNetwork (Recommended)

Google recommends using Google Mobile Ads SDK 7.64.0 or higher, which supports SKAdNetwork for conversion tracking even when IDFA is unavailable. Update the `SKAdNetworkItems` key in your `Info.plist`. [See Google's guide for details](https://developers.google.com/admob/ios/ios14#skadnetwork).

### Basic Example

```dart
import 'package:app_tracking_transparency_plus/app_tracking_transparency_plus.dart';

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      final status = await AppTrackingTransparencyPlus.requestTrackingAuthorization();
    });
  }
}
```

### Recommended: Explainer Dialog

Google recommends showing an explainer message before the system dialog:

```dart
if (await AppTrackingTransparencyPlus.trackingAuthorizationStatus ==
    TrackingStatus.notDetermined) {
  // Show a custom explainer dialog before the system dialog
  await showCustomTrackingDialog(context);
  // Wait for dialog popping animation
  await Future.delayed(const Duration(milliseconds: 200));
  // Request system's tracking authorization dialog
  await AppTrackingTransparencyPlus.requestTrackingAuthorization();
}
```

The explainer dialog must not contain a "Decide later" button. It should contain only a "Continue" button, and the system dialog must be shown after the explainer dialog. [See this issue for details](https://github.com/deniza/app_tracking_transparency/issues/27).

### Get Advertising Identifier

```dart
final uuid = await AppTrackingTransparencyPlus.getAdvertisingIdentifier();
```

Until a user grants authorization, the returned UUID will be all zeros: `00000000-0000-0000-0000-000000000000`. Also note, the `advertisingIdentifier` will be all zeros in the Simulator, regardless of the tracking authorization status.

## API Reference

| Method / Property | Description |
|---|---|
| `requestTrackingAuthorization()` | Displays the tracking authorization dialog and returns the user's decision. |
| `trackingAuthorizationStatus` | Returns the current `TrackingStatus` without showing a dialog. |
| `getAdvertisingIdentifier()` | Returns the advertising identifier (IDFA), or zeros if unauthorized. |

### TrackingStatus

| Value | Description |
|---|---|
| `notDetermined` | The user has not yet been asked for tracking authorization. |
| `restricted` | Tracking is restricted (e.g., due to parental controls). |
| `denied` | The user denied tracking authorization. |
| `authorized` | The user granted tracking authorization. |

## Requirements

- **Flutter** >= 3.41.0
- **Dart SDK** >= 3.11.0
- **iOS** 13.0+
- **Xcode** 15+

## Important Notice

iOS does not allow displaying multiple native dialogs simultaneously. If you attempt to show a native dialog while another is already on screen, the previous dialog will be forcefully closed by the system. It is very common to show a notification permission dialog on the first run of an iOS application. If you try to show both a notification permission dialog and an app tracking request dialog, one of them will be cancelled.

**Recommended approach:** Use an explainer dialog before requesting tracking authorization. Check the sample project for more details.

**Alternative approach:** Postpone the permission request until the 2nd or Nth run of the application. If you choose this way, make sure to inform the App Store reviewer that you postponed the tracking request, or your submission may be rejected.

Always test on a real device with a freshly installed application.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
