// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'data_source_test.dart' as data_source_test;
import 'test_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final binding = TestDefaultBinaryMessengerBinding.instance;
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    // 필요한 로직 추가
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return './test_directory';
    }
    return null;
  });

  TestUtil.deleteDatabaseFile('db.sqlite');

  data_source_test.main();
}
