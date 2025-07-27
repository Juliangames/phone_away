import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MotivationalSaying extends StatefulWidget {
  final String text;

  const MotivationalSaying({super.key, required this.text});

  @override
  State<MotivationalSaying> createState() => _MotivationalSayingState();
}

class _MotivationalSayingState extends State<MotivationalSaying> {
  ui.Image? _appleImage;

  @override
  void initState() {
    super.initState();
    _loadAppleImage();
  }

  Future<void> _loadAppleImage() async {
    final data = await rootBundle.load('assets/images/apple.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    if (mounted) {
      setState(() {
        _appleImage = frame.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Container(
      width: 250,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.text, style: textStyle, textAlign: TextAlign.center),
          const SizedBox(width: 8),
          if (_appleImage != null)
            RawImage(image: _appleImage, width: 24, height: 24)
          else
            const SizedBox(width: 24, height: 24), // Placeholder space
        ],
      ),
    );
  }
}
