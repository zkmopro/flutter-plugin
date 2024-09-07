# Cross-Platform Mobile ZKPs

Flutter is a popular cross-platform mobile app development framework. Mopro Flutter shows an example of integrating the ZK-proving into a Flutter app, allowing to streamline the creation of ZK-enabled mobile apps.

# Running The Example App

- Open the project in VS Code
- Open "Run and Debug"
- Start an emulator (iOS/Android) or connect your phone
- Select "example" in the run menu and press run

# Integrating Your ZKP

The example app comes with a simple prover generated from a Circom circuit. To integrate your own prover, follow the steps below.

## Setup

- Follow the [Rust Setup steps from the MoPro official docs](https://zkmopro.org/docs/getting-started/rust-setup) to generate the platform-specific libraries.

## Copying The Generated Libraries

### iOS

- Replace `mopro.swift` at [`ios/Classes/mopro.swift`](ios/Classes/mopro.swift) with the file generated during the [Setup](#setup)
- Replace the directory [`ios/MoproBindings.xcframework`](ios/MoproBindings.xcframework) with the one generated during the [Setup](#setup)

### Android

- Replace the directory [`android/src/main/jniLibs`](android/src/main/jniLibs) with the one generated during the [Setup](#setup)
- Replace `mopro.kt` at [`android/src/main/kotlin/uniffi/mopro/mopro.kt`](android/src/main/kotlin/uniffi/mopro/mopro.kt) with the file generated during the [Setup](#setup)

## zKey

- Put your zKey file in your app assets. For example, to run the included example app, you need to replace the zKey at [`example/assets/multiplier2_final.zkey`](example/assets/multiplier2_final.zkey) with your file. If you change the zKey file name, don't forget to change the asset definition in your app's `pubspec.yaml`. For example, here: [`example/pubspec.yaml`](example/pubspec.yaml)

```yaml
assets:
  - assets/multiplier2_final.zkey
```

If you have changed the zKey asset name, don't forget to also correctly load it. For example, here: [`example/lib/main.dart`](example/lib/main.dart)

```dart
var inputs = <String, List<String>>{};
inputs["a"] = ["3"];
inputs["b"] = ["5"];
proofResult = await _moproFlutterPlugin.generateProof("assets/multiplier2_final.zkey", inputs);
```

Don't forget to modify the input values for your specific case!
