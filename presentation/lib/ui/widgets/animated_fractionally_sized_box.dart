import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';

class AnimatedFractionallySizedBox extends StatelessWidget {
  final double targetWidthFactor;
  final Duration duration;

  const AnimatedFractionallySizedBox({
    super.key,
    required this.targetWidthFactor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetWidthFactor),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, animatedValue, child) {
        return FractionallySizedBox(
          widthFactor: animatedValue,
          child: Container(
            width: double.infinity,
            height: 26,
            decoration: BoxDecoration(
              color: DsColorPalette.gray700,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
