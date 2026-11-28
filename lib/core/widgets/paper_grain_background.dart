import 'dart:math' as math;
import 'dart:ui' show PointMode;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Uygulama arka planına çok hafif "defter kâğıdı / grain" dokusu katan katman.
///
/// [RepaintBoundary] ile önbelleklenir; kaydırma veya animasyon sırasında yeniden
/// çizilmez ve dokunma olaylarını ([IgnorePointer]) engellemez.
class PaperGrainOverlay extends StatelessWidget {
  final Widget child;

  const PaperGrainOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final grainColor = context.colors.paperGrain;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              willChange: false,
              painter: _PaperGrainPainter(color: grainColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaperGrainPainter extends CustomPainter {
  final Color color;

  const _PaperGrainPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || color.a <= 0) return;

    final primaryPaint = Paint()
      ..color = color
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.round;

    final softPaint = Paint()
      ..color = color.withValues(alpha: color.a * 0.55)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // Deterministik tohum ile doğal kâğıt lif/tanecik dağılımı
    final rng = math.Random(4209);
    const step = 18.0;
    final cols = (size.width / step).ceil();
    final rows = (size.height / step).ceil();

    final primaryPoints = <Offset>[];
    final softPoints = <Offset>[];

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final dx = (c + rng.nextDouble()) * step;
        final dy = (r + rng.nextDouble()) * step;
        if (dx <= size.width && dy <= size.height) {
          if ((r + c).isEven) {
            primaryPoints.add(Offset(dx, dy));
          } else {
            softPoints.add(Offset(dx, dy));
          }
        }
      }
    }

    canvas.drawPoints(
      // PointMode.points için dart:ui yerine tekil kısa izler ya da drawRawPoints
      // yerine hafif mikro-noktalar:
      // drawCircle yerine drawPoints(PointMode.points) çok hızlıdır.
      // dart:ui PointMode kullanımı için:
      _pointMode,
      primaryPoints,
      primaryPaint,
    );
    canvas.drawPoints(_pointMode, softPoints, softPaint);
  }

  // ignore: avoid_private_typedef_functions
  static const _pointMode = PointMode.points;

  @override
  bool shouldRepaint(covariant _PaperGrainPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
