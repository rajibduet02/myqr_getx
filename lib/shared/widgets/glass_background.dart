import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8F5),
            Color(0xFFF7F7F7),
            Color(0xFFFFEDE6),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _blob(
            top: -90,
            right: -70,
            size: 240,
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
          _blob(
            bottom: 80,
            left: -50,
            size: 200,
            color: AppColors.primaryLight.withValues(alpha: 0.14),
          ),
          _blob(
            top: 280,
            left: 40,
            size: 140,
            color: AppColors.charcoal.withValues(alpha: 0.05),
          ),
          _blob(
            bottom: -40,
            right: 30,
            size: 180,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _blob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 60,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
