import 'dart:ui';

class FutureUtils {
  static Future<void> runDelayed(VoidCallback action) async {
    await Future.delayed(const Duration(milliseconds: 300));
    action();
  }
}
