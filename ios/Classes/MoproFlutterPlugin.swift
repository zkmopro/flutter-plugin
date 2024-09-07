import Flutter
import UIKit
import moproFFI


public class MoproFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mopro_flutter", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec())
    let instance = MoproFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "generateProof":
      guard let args = call.arguments as? [String: Any],
            let zkeyPath = args["zkeyPath"] as? String,
            let inputs = args["inputs"] as? [String: [String]] else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments", details: nil))
        return
      }

      do {
        // Call the function from mopro.swift
        let proofResult = try generateCircomProof(zkeyPath: zkeyPath, circuitInputs: inputs)
        
        // Convert proof and inputs to Base64 strings
        let proofBase64 = proofResult.proof.base64EncodedString()
        let inputsBase64 = proofResult.inputs.base64EncodedString()

        // Build the response
        let response: [String: String] = [
          "proof": proofBase64,
          "inputs": inputsBase64
        ]

        // Return the response to Flutter
        result(response)
      } catch {
        result(FlutterError(code: "PROOF_GENERATION_ERROR", message: "Failed to generate proof", details: error.localizedDescription))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
