import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool isFilled;
  final bool? isError;

  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isFilled = true,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor:
          isError == true
              ? Theme.of(context).colorScheme.error
              : isFilled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
      foregroundColor: isError == true 
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.onPrimary,
      minimumSize: const Size(154, 54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      padding: const EdgeInsets.symmetric(horizontal: 24),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: FilledButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.43,
                letterSpacing: 0.10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
