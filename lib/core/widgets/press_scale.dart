import 'package:flutter/material.dart';

/// A small reusable press interaction with subtle scale feedback.
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final double pressedScale;

  final bool useSplash;

  const PressScale({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.pressedScale = 0.97,
    this.useSplash = true,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      onPointerUp: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        scale: _isPressed ? widget.pressedScale : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: widget.borderRadius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: widget.borderRadius,
            splashFactory: widget.useSplash ? InkSparkle.splashFactory : NoSplash.splashFactory,
            highlightColor: widget.useSplash ? null : Colors.transparent,
            splashColor: widget.useSplash ? null : Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
