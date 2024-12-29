import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TestUtil {
  static Future<void> deleteDatabaseFile(String dbName) async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = '${directory.path}/$dbName';
    final file = File(dbPath);

    if (await file.exists()) {
      await file.delete();
    }
  }
}
