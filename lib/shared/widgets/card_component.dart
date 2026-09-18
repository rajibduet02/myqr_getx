import 'package:flutter/material.dart';

import 'glass_container.dart';

class CardComponent extends StatelessWidget {
  final Color? color;
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CardComponent({
    super.key,
    this.color,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: margin ?? const EdgeInsets.only(bottom: 8, top: 8),
      padding: padding ?? EdgeInsets.zero,
      color: color,
      strong: true,
      onTap: onTap,
      child: child,
    );
  }
}
