import 'dart:math' as math;

import 'package:flutter/material.dart';

class Apple {
  final bool isRotten;

  const Apple({this.isRotten = false});
}

class AppleTreeWidget extends StatelessWidget {
  final List<Apple> apples;
  final double baseSize;
  final double scale;

  const AppleTreeWidget({
    super.key,
    required this.apples,
    this.baseSize = 200,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final size = baseSize * scale;
    return CustomPaint(size: Size.square(size), painter: _TreePainter(apples));
  }
}

class _TreePainter extends CustomPainter {
  _TreePainter(this.apples);

  final List<Apple> apples;
  static const _appleRadius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final crownCenter = center.translate(0, -size.height * .18);
    final crownRadius = size.width * .34;

    _drawTrunk(canvas, center, size);
    _drawFoliage(canvas, crownCenter, crownRadius);
    _drawApples(canvas, crownCenter, crownRadius);
  }

  void _drawTrunk(Canvas canvas, Offset center, Size size) {
    final width = size.width * .12;
    final height = size.height * .45;
    final rect = Rect.fromCenter(
      center: center.translate(0, height * .3),
      width: width,
      height: height,
    );
    canvas.drawRect(rect, Paint()..color = const Color(0xFF8B5A2B));
  }

  void _drawFoliage(Canvas canvas, Offset center, double baseRadius) {
    final rng = math.Random(apples.length);
    for (var i = 0; i < 7; i++) {
      final radius = baseRadius * (.45 + rng.nextDouble() * .35);
      final angle = rng.nextDouble() * 2 * math.pi;
      final offset =
          center +
          Offset(math.cos(angle), math.sin(angle)) * (baseRadius - radius * .4);
      final color =
          HSLColor.fromAHSL(
            1,
            80 + rng.nextDouble() * 20,
            .5 + rng.nextDouble() * .3,
            .35 + rng.nextDouble() * .25,
          ).toColor();
      canvas.drawCircle(offset, radius, Paint()..color = color);
    }
  }

  void _drawApples(Canvas canvas, Offset center, double baseRadius) {
    final fresh = Paint()..color = Colors.red;
    final rotten = Paint()..color = const Color(0xFF8E6B38);

    for (var i = 0; i < apples.length; i++) {
      final rand = math.Random(i * 9973);
      final distance = rand.nextDouble() * baseRadius * 1.2;
      final angle = rand.nextDouble() * 2 * math.pi;
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(pos, _appleRadius, apples[i].isRotten ? rotten : fresh);
    }
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) =>
      oldDelegate.apples != apples;
}
