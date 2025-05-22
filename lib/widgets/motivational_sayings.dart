import 'package:flutter/material.dart';
import '../theme/theme.dart';

class MotivationalSaying extends StatelessWidget {
  final String text;

  const MotivationalSaying({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      color: AppColors.onSurfaceVariantColor,
    );

    return Container(
      width: 354,
      height: 58,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerHighestColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),
      child: Center(
        child: Text(text, style: textStyle, textAlign: TextAlign.center),
      ),
    );
  }
}
