import 'dart:math' as math;
import 'dart:ui' as ui; // Wichtig für ui.Image

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// --- Haupt-Widget: Jetzt StatefulWidget, um Bilder laden und halten zu können ---
class AppleTreeWidget extends StatefulWidget {
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
  State<AppleTreeWidget> createState() => _AppleTreeWidgetState();
}

class _AppleTreeWidgetState extends State<AppleTreeWidget> {
  // Variablen, um die geladenen Bilder zu halten. Null, bis sie geladen sind.
  ui.Image? _treeImage;
  ui.Image? _appleImage;
  ui.Image? _rottenAppleImage;
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // Lädt alle benötigten Bilder aus den Assets
  Future<void> _loadImages() async {
    // Lade alle Bilder parallel
    final results = await Future.wait([
      _loadImage('assets/images/tree.png'),
      _loadImage('assets/images/apple.png'),
      _loadImage('assets/images/rotten_apple.png'),
    ]);

    // Wenn das Widget noch im Baum ist, aktualisiere den State
    if (mounted) {
      setState(() {
        _treeImage = results[0];
        _appleImage = results[1];
        _rottenAppleImage = results[2];
        _imagesLoaded =
            _treeImage != null &&
            _appleImage != null &&
            _rottenAppleImage != null;
      });
    }
  }

  // Hilfsfunktion, um ein einzelnes Bild zu laden und zu dekodieren
  Future<ui.Image> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  Widget build(BuildContext context) {
    // Zeige einen Ladekreis, bis alle Bilder verfügbar sind
    if (!_imagesLoaded) {
      return SizedBox(
        width: widget.baseSize * widget.scale,
        height: widget.baseSize * widget.scale,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Wenn Bilder geladen sind, zeichne den CustomPainter
    return CustomPaint(
      size: Size.square(widget.baseSize * widget.scale),
      painter: _TreePainter(
        apples: widget.apples,
        rottenApples: widget.rottenApples,
        treeImage: _treeImage!,
        appleImage: _appleImage!,
        rottenAppleImage: _rottenAppleImage!,
      ),
    );
  }
}

// --- Der Painter: Nimmt jetzt ui.Image Objekte entgegen ---
class _TreePainter extends CustomPainter {
  final int apples;
  final int rottenApples;
  final ui.Image treeImage;
  final ui.Image appleImage;
  final ui.Image rottenAppleImage;

  _TreePainter({
    required this.apples,
    required this.rottenApples,
    required this.treeImage,
    required this.appleImage,
    required this.rottenAppleImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Zeichne das Baum-Bild über die gesamte Fläche
    _drawTree(canvas, size);

    // 2. Zeichne die Äpfel an zufälligen Positionen über dem Baum
    // Definiere einen Bereich, in dem die Äpfel erscheinen sollen (z.B. die obere Hälfte)
    final crownRect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.05,
      size.width * 0.5,
      size.height * 0.4,
    );
    _drawApples(canvas, crownRect);
  }

  void _drawTree(Canvas canvas, Size size) {
    final paint = Paint();
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final sourceRect = Rect.fromLTWH(
      0,
      0,
      treeImage.width.toDouble(),
      treeImage.height.toDouble(),
    );
    canvas.drawImageRect(treeImage, sourceRect, destinationRect, paint);
  }

  void _drawApples(Canvas canvas, Rect bounds) {
    final paint = Paint();
    final appleSize = Size.square(bounds.width * 0.12); // Größe der Äpfel

    // Gute Äpfel zeichnen
    for (var i = 0; i < apples; i++) {
      final rand = math.Random(i * 9973);
      final pos = Offset(
        bounds.left + rand.nextDouble() * bounds.width,
        bounds.top + rand.nextDouble() * bounds.height,
      );
      final appleRect = Rect.fromCenter(
        center: pos,
        width: appleSize.width,
        height: appleSize.height,
      );
      final sourceRect = Rect.fromLTWH(
        0,
        0,
        appleImage.width.toDouble(),
        appleImage.height.toDouble(),
      );
      canvas.drawImageRect(appleImage, sourceRect, appleRect, paint);
    }

    // Faule Äpfel zeichnen
    for (var i = 0; i < rottenApples; i++) {
      final rand = math.Random((i + apples) * 9973);
      final pos = Offset(
        bounds.left + rand.nextDouble() * bounds.width,
        bounds.top + rand.nextDouble() * bounds.height,
      );
      final appleRect = Rect.fromCenter(
        center: pos,
        width: appleSize.width,
        height: appleSize.height,
      );
      final sourceRect = Rect.fromLTWH(
        0,
        0,
        rottenAppleImage.width.toDouble(),
        rottenAppleImage.height.toDouble(),
      );
      canvas.drawImageRect(rottenAppleImage, sourceRect, appleRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreePainter old) {
    // Neu zeichnen, wenn sich die Apfelanzahl ändert
    return old.apples != apples || old.rottenApples != rottenApples;
  }
}
