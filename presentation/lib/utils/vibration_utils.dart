import 'package:vibration/vibration.dart';

void triggerStrongVibration() async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: 200, amplitude: 255);
  }
}
