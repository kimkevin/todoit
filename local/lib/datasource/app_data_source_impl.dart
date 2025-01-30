import 'package:data/datasource/app_data_source.dart';
import 'package:local/preferences/app_preferences.dart';

class AppDataSourceImpl extends AppDataSource {
  final AppPreferences preferences;

  AppDataSourceImpl({required this.preferences});

  @override
  String? getLastClipboardHash() => preferences.getLastClipboardHash();

  @override
  Future<bool> setLastClipboardHash(String clipboardHash) =>
      preferences.setLastClipboardHash(clipboardHash);
}
