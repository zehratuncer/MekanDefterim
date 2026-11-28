import 'package:flutter/material.dart';
import '../theme/app_motion.dart';
import '../utils/app_haptics.dart';

/// Basıldığında 0.96 ölçeğine küçülen ve dokunsal (haptic) geri bildirim veren sarmalayıcı.
///
/// - Kart/özel widget'lar için varsayılan kurucu ([PressableScale]) dokunma olaylarını yönetir.
/// - `ElevatedButton` / `OutlinedButton` gibi kendi `onPressed` yöneticisi olan Material butonlar
///   için [PressableScale.button] kullanılır; gesture arena çakışması yaratmadan ölçekleme sağlar.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedScale;
  final bool enableHaptic;
  final Future<void> Function()? hapticFeedback;
  final HitTestBehavior behavior;
  final bool _passthrough;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = AppMotion.pressScale,
    this.enableHaptic = true,
    this.hapticFeedback,
    this.behavior = HitTestBehavior.opaque,
  }) : _passthrough = false;

  /// Kendi tıklama işleyicisine sahip butonları sarmalamak için kullanılır.
  const PressableScale.button({
    super.key,
    required this.child,
    this.pressedScale = AppMotion.pressScale,
    this.enableHaptic = true,
    this.hapticFeedback,
    bool enabled = true,
  })  : onTap = null,
        onLongPress = null,
        behavior = HitTestBehavior.deferToChild,
        _passthrough = enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _isPressed = false;

  bool get _isInteractive =>
      widget._passthrough || widget.onTap != null || widget.onLongPress != null;

  void _setPressed(bool value) {
    if (!_isInteractive || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  void _triggerHaptic() {
    if (!widget.enableHaptic) return;
    final feedback = widget.hapticFeedback;
    if (feedback != null) {
      feedback();
    } else {
      AppHaptics.tap();
    }
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    _triggerHaptic();
    widget.onTap!();
  }

  void _handleLongPress() {
    if (widget.onLongPress == null) return;
    if (widget.enableHaptic) {
      AppHaptics.longPress();
    }
    widget.onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInteractive) return widget.child;

    final reducedMotion = AppMotion.isReducedMotion(context);
    final scale = (!reducedMotion && _isPressed) ? widget.pressedScale : 1.0;

    final animatedChild = AnimatedScale(
      scale: scale,
      duration: reducedMotion ? Duration.zero : AppMotion.fast,
      curve: _isPressed ? AppMotion.curve : AppMotion.springCurve,
      child: widget.child,
    );

    if (widget._passthrough) {
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          _setPressed(true);
          _triggerHaptic();
        },
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: animatedChild,
      );
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      child: animatedChild,
    );
  }
}
