import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mopro_flutter/mopro_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GenerateProofResult? _proofResult;
  final _moproFlutterPlugin = MoproFlutter();
  bool isProving = false;
  PlatformException? _error;

  @override
  Widget build(BuildContext context) {
    // The inputs is a base64 string
    var inputs = _proofResult?.inputs ?? "";
    // The proof is a base64 string
    var proof = _proofResult?.proof ?? "";
    // Decode the proof and inputs to see the actual values
    var decodedProof = base64Decode(proof);
    var decodedInputs = base64Decode(inputs);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App With MoPro'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isProving) const CircularProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_error.toString()),
              ),
            if (_proofResult != null)
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Proof inputs: $decodedInputs'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Proof: $decodedProof'),
                    ),
                  ],
                ),
              ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      onPressed: () async {
                        Map<String, dynamic>? proofResult;
                        PlatformException? error;
                        // Platform messages may fail, so we use a try/catch PlatformException.
                        // We also handle the message potentially returning null.
                        try {
                          var inputs = <String, List<String>>{};
                          inputs["a"] = ["3"];
                          inputs["b"] = ["5"];
                          proofResult = await _moproFlutterPlugin.generateProof(
                              "assets/multiplier2_final.zkey", inputs);
                          print(
                            "Proof result: $proofResult",
                          );
                        } on PlatformException catch (e) {
                          print("Error: $e");
                          error = e;
                          proofResult = null;
                        }

                        // If the widget was removed from the tree while the asynchronous platform
                        // message was in flight, we want to discard the reply rather than calling
                        // setState to update our non-existent appearance.
                        if (!mounted) return;

                        setState(() {
                          _proofResult = proofResult == null
                              ? null
                              : GenerateProofResult(
                                  proofResult["proof"], proofResult["inputs"]);
                          _error = error;
                        });
                      },
                      child: Text(
                        "Generate Proof",
                        style: Theme.of(context).textTheme.headlineLarge,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
