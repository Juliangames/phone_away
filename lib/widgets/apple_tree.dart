import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppleTreeWidget extends StatelessWidget {
  final int apples;
  final int rottenApples;
  final double baseSize;
  final double scale;

  const AppleTreeWidget({
    super.key,
    required this.apples,
    required this.rottenApples,
    this.baseSize = 200,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final size = baseSize * scale;
    return CustomPaint(
      size: Size.square(size),
      painter: _TreePainter(apples, rottenApples),
    );
  }
}

class _TreePainter extends CustomPainter {
  final int apples;
  final int rottenApples;
  _TreePainter(this.apples, this.rottenApples);

  static const _appleRadius = 10.0; // nur für Fontgröße

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final crownCenter = center.translate(0, -size.height * .18);
    final crownRadius = size.width * .34;

    _drawTrunk(canvas, center, size);
    _drawFoliage(canvas, crownCenter, crownRadius);
    _drawApples(canvas, crownCenter, crownRadius);
  }

  void _drawTrunk(Canvas canvas, Offset c, Size s) {
    final w = s.width * .12;
    final h = s.height * .45;
    canvas.drawRect(
      Rect.fromCenter(center: c.translate(0, h * .3), width: w, height: h),
      Paint()..color = const Color(0xFF8B5A2B),
    );
  }

  void _drawFoliage(Canvas canvas, Offset c, double r) {
    final rng = math.Random(apples);
    for (var i = 0; i < 7; i++) {
      final leafR = r * (.45 + rng.nextDouble() * .35);
      final a = rng.nextDouble() * 2 * math.pi;
      final o = c + Offset(math.cos(a), math.sin(a)) * (r - leafR * .4);
      final col =
          HSLColor.fromAHSL(
            1,
            80 + rng.nextDouble() * 20,
            .5 + rng.nextDouble() * .3,
            .35 + rng.nextDouble() * .25,
          ).toColor();
      canvas.drawCircle(o, leafR, Paint()..color = col);
    }
  }

  void _drawApples(Canvas canvas, Offset c, double r) {
    const freshEmoji = '🍎';
    const rottenEmoji = '🍏';

    for (var i = 0; i < apples; i++) {
      final rand = math.Random(i * 9973);
      final d = rand.nextDouble() * r * 1.2;
      final a = rand.nextDouble() * 2 * math.pi;
      final pos = c + Offset(math.cos(a), math.sin(a)) * d;
      final tp = TextPainter(
        text: TextSpan(
          text: freshEmoji,
          style: TextStyle(fontSize: _appleRadius * 2.4),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    for (var i = 0; i < rottenApples; i++) {
      final rand = math.Random(i * 9973);
      final d = rand.nextDouble() * r * 1.2;
      final a = rand.nextDouble() * 2 * math.pi;
      final pos = c + Offset(math.cos(a), math.sin(a)) * d;
      final tp = TextPainter(
        text: TextSpan(
          text: rottenEmoji,
          style: TextStyle(fontSize: _appleRadius * 2.4),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _TreePainter old) => old.apples != apples;
}
