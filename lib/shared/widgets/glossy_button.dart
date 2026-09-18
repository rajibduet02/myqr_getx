import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class GlossyButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String buttonText;
  final IconData? tapIcon;
  final IconData? normalIcon;
  final VoidCallback? onTap;

  const GlossyButton({
    super.key,
    this.color1 = AppColors.primaryLight,
    this.color2 = AppColors.primary,
    this.buttonText = 'Button Text',
    this.tapIcon,
    this.normalIcon,
    this.onTap,
  });

  @override
  State<GlossyButton> createState() => _GlossyButtonState();
}

class _GlossyButtonState extends State<GlossyButton> {
  var glowing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) => setState(() => glowing = false),
      onTapDown: (_) => setState(() => glowing = true),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 100),
        height: 48,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(colors: [widget.color1, widget.color2]),
          boxShadow: glowing
              ? [
                  BoxShadow(
                    color: widget.color1.withValues(alpha: 0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: const Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color2.withValues(alpha: 0.6),
                    spreadRadius: 1,
                    blurRadius: 16,
                    offset: const Offset(8, 0),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              glowing ? widget.tapIcon : widget.normalIcon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(widget.buttonText, style: AppStyles.buttonText),
          ],
        ),
      ),
    );
  }
}
