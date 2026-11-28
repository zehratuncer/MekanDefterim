import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import 'pressable_scale.dart';

/// Mekan Defteri'm Standart Kart Bileşeni (Faz 9.0)
///
/// Özellikler:
/// - Üstten alta hafif yüzey gradient'i
/// - 1px çevre kenarlık + 1px açık üst kenar parlaması (rim highlight)
/// - Tutarlı yumuşak gölge
/// - Standart yarıçap tokenı ([AppRadius.md] = 20 varsayılan)
/// - [onTap] / [onLongPress] verildiğinde otomatik [PressableScale] etkileşimi
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final bool showShadow;
  final bool showTopHighlight;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = AppRadius.md,
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.showShadow = true,
    this.showTopHighlight = true,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderRadius = BorderRadius.circular(radius);

    Widget content = Container(
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundColor == null ? (gradient ?? colors.cardGradient) : null,
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColor ?? colors.cardBorder,
          width: 1,
        ),
        boxShadow: showShadow ? colors.cardShadow : null,
      ),
      child: CustomPaint(
        foregroundPainter: showTopHighlight
            ? _TopEdgeHighlightPainter(
                color: colors.cardHighlight,
                radius: radius,
              )
            : null,
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );

    if (onTap != null || onLongPress != null) {
      content = PressableScale(
        onTap: onTap,
        onLongPress: onLongPress,
        child: content,
      );
    }

    return content;
  }
}

class _TopEdgeHighlightPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _TopEdgeHighlightPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular((radius - 0.5).clamp(0.0, radius)),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.32],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _TopEdgeHighlightPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
