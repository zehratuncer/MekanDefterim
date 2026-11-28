import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// Tekil bir liste öğesini kademeli (staggered) fade + yukarı kayma ile ekrana sokar.
///
/// "Animasyonları azalt" erişilebilirlik ayarı açıksa veya öğe ilk görünür grubun
/// ötesindeyse ([maxAnimatedIndex]) doğrudan çizilir (60 fps kaydırma performansı).
class StaggeredItem extends StatelessWidget {
  final int index;
  final Widget child;
  final int maxAnimatedIndex;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.maxAnimatedIndex = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (AppMotion.isReducedMotion(context) || index > maxAnimatedIndex) {
      return child;
    }

    final delay = Duration(
      milliseconds: index * AppMotion.staggerStep.inMilliseconds,
    );

    return child
        .animate(delay: delay)
        .fadeIn(duration: AppMotion.normal, curve: AppMotion.curve)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppMotion.normal,
          curve: AppMotion.curve,
        );
  }
}

/// Öğelerini otomatik olarak [StaggeredItem] ile sarmalayan kademeli liste bileşeni.
class StaggeredList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;

  const StaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
