import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';

class RoundedTextFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  const RoundedTextFloatingActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Row(
        children: [
          icon,
          const SizedBox(width: 10.0),
          Text(
            text,
            style: DsTextStyles.b2.copyWith(color: DsColorPalette.white),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: DsColorPalette.gray700,
      foregroundColor: Colors.white,
      elevation: 2,
      extendedPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
