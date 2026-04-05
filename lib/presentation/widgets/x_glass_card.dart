// ============================================================
// x_glass_card.dart
// ------------------------------------------------------------
// UI Widget: Frosted Glass container (Glassmorphism)
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/x_colors.dart';

class XGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Border? border;
  final EdgeInsetsGeometry? padding;

  const XGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 16.0,
    this.color,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? (isDark ? XColors.glassDark : XColors.glassWhite),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
