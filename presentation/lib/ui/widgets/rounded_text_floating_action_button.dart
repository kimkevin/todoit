import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:presentation/temp_ds.dart';

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
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ).copyWith(color: DsTextColors.primary),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: context.theme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    );
  }
}
