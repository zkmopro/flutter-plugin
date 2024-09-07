package com.example.mopro_flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.content.Context
import kotlinx.coroutines.launch
import uniffi.mopro.generateCircomProof
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

import org.json.JSONObject
import android.util.Base64
import android.util.Log
import io.flutter.plugin.common.JSONMethodCodec
import uniffi.mopro.GenerateProofResult

/** MoproFlutterPlugin */
class MoproFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mopro_flutter", JSONMethodCodec.INSTANCE)
    channel.setMethodCallHandler(this)
  }

  fun JSONObject.toMap(): Map<String, List<String>> {
    val map = mutableMapOf<String, List<String>>()
    this.keys().forEach { key ->
      val list = mutableListOf<String>()
      val jsonArray = this.getJSONArray(key)
      for (i in 0 until jsonArray.length()) {
        list.add(jsonArray.getString(i))
      }
      map[key] = list
    }
    return map
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "generateProof") {
      val zkeyPath = call.argument<String>("zkeyPath") ?: return result.error("ARGUMENT_ERROR", "Missing zkeyPath", null)

      val inputsJson = call.argument<JSONObject>("inputs") ?: return result.error("ARGUMENT_ERROR", "Missing inputs", null)
      val inputs = inputsJson.toMap() as Map<String, List<String>>
 
      val res: GenerateProofResult = generateCircomProof(zkeyPath, inputs)

      Log.d("generateProof", "$res")
      // Convert ByteArray fields to Base64 strings
        val proofBase64 = Base64.encodeToString(res.proof, Base64.NO_WRAP)
        val inputsBase64 = Base64.encodeToString(res.inputs, Base64.NO_WRAP)

        // Build the JSON response
        val json = JSONObject().apply {
            put("proof", proofBase64)  // Base64-encoded proof
            put("inputs", inputsBase64)  // Base64-encoded inputs
        }

        // Send the JSON string back to Flutter
        result.success(
          json
        )
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
