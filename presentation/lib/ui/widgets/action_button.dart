import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';

class ActionButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onClick;

  const ActionButton({
    super.key,
    required this.buttonName,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.primary,
          fixedSize: Size.fromHeight(64),
          minimumSize: Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 18).copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
