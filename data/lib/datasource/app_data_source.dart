abstract class AppDataSource {
  String? getLastClipboardHash();

  Future<bool> setLastClipboardHash(String clipboardHash);
}
