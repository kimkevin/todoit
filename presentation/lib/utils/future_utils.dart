import 'dart:ui';

class FutureUtils {
  static Future<void> runDelayed(VoidCallback action, {int millis = 300}) =>
      Future.delayed(Duration(milliseconds: millis), () {
        action();
      });
}
