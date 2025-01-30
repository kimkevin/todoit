import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _keyLastClipboardHash = "key_last_clipboard_hash";

  static final AppPreferences _instance = AppPreferences._internal();
  factory AppPreferences() => _instance;

  late SharedPreferences _prefs;

  AppPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getLastClipboardHash() => _prefs.getString(_keyLastClipboardHash);

  Future<bool> setLastClipboardHash(String clipboardHash) async {
    return await _prefs.setString(_keyLastClipboardHash, clipboardHash);
  }
}
