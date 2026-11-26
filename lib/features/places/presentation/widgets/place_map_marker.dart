import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_status.dart';

class PlaceMapMarker extends StatelessWidget {
  final Place place;
  final bool isSelected;
  final VoidCallback onTap;

  const PlaceMapMarker({
    super.key,
    required this.place,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVisited = place.status == PlaceStatus.visited;
    final bgColor = isVisited ? AppColors.primary : AppColors.accent;
    final icon = isVisited ? Icons.check_rounded : Icons.favorite_rounded;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : AppColors.backgroundDark,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(110),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            CustomPaint(
              size: const Size(10, 6),
              painter: _PinPointerPainter(color: bgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinPointerPainter extends CustomPainter {
  final Color color;

  const _PinPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinPointerPainter oldDelegate) => oldDelegate.color != color;
}
