// ============================================================
// x_pulse_button.dart
// ------------------------------------------------------------
// UI Widget: Pulsing animation button for "MATCH" catalyst.
// ============================================================

import 'package:flutter/material.dart';
import '../../core/theme/x_colors.dart';

class XPulseButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double size;

  const XPulseButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.size = 144.0,
  });

  @override
  State<XPulseButton> createState() => _XPulseButtonState();
}

class _XPulseButtonState extends State<XPulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? XColors.primaryPurple;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Rings (Animated)
        ...List.generate(2, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = (index + _controller.value) * 1.5;
              final opacity = (1 - _controller.value) * 0.4;
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: opacity),
                    width: 2,
                  ),
                ),
                transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                transformAlignment: Alignment.center,
              );
            },
          );
        }),
        
        // Inner Button
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ],
    );
  }
}
