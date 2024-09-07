import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_flutter_platform_interface.dart';
import 'package:mopro_flutter/mopro_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoproFlutterPlatform
    with MockPlatformInterfaceMixin
    implements MoproFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MoproFlutterPlatform initialPlatform = MoproFlutterPlatform.instance;

  test('$MethodChannelMoproFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoproFlutter>());
  });

  test('getPlatformVersion', () async {
    MoproFlutter moproFlutterPlugin = MoproFlutter();
    MockMoproFlutterPlatform fakePlatform = MockMoproFlutterPlatform();
    MoproFlutterPlatform.instance = fakePlatform;

    expect(await moproFlutterPlugin.getPlatformVersion(), '42');
  });
}
