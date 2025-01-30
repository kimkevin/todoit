abstract class AppRepository {
  String? getLastClipboardHash();

  Future<bool> setLastClipboardHash(String clipboardHash);
}
