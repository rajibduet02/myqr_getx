import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../controller/scan_controller.dart';

const double _scanMenuBorderRadius = 18;
const double _scanMenuMinWidth = 240;

class ScanGlassOptionsMenu extends StatefulWidget {
  const ScanGlassOptionsMenu({
    super.key,
    required this.controller,
  });

  final ScanController controller;

  @override
  State<ScanGlassOptionsMenu> createState() => _ScanGlassOptionsMenuState();
}

class _ScanGlassOptionsMenuState extends State<ScanGlassOptionsMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1).animate(_fadeAnimation);
  }

  @override
  void dispose() {
    _removeOverlay(immediate: true);
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    final renderBox = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlay == null || renderBox == null) {
      return;
    }

    final buttonOffset = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final screenSize = MediaQuery.sizeOf(context);
    const menuGap = 8.0;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        final isDark = Theme.of(overlayContext).brightness == Brightness.dark;
        final top = buttonOffset.dy + buttonSize.height + menuGap;
        final right = screenSize.width - (buttonOffset.dx + buttonSize.width);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeMenu,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: top,
              right: right,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  alignment: Alignment.topRight,
                  scale: _scaleAnimation,
                  child: _ScanGlassMenuSurface(
                    isDark: isDark,
                    controller: widget.controller,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
    _animationController.forward(from: 0);
  }

  Future<void> _closeMenu() async {
    if (_overlayEntry == null) {
      return;
    }

    await _animationController.reverse();
    _removeOverlay();
  }

  void _removeOverlay({bool immediate = false}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (immediate) {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _anchorKey,
      icon: const Icon(Icons.more_vert, color: Colors.white),
      tooltip: 'Scan options',
      onPressed: _toggleMenu,
    );
  }
}

class _ScanGlassMenuSurface extends StatelessWidget {
  const _ScanGlassMenuSurface({
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final ScanController controller;

  @override
  Widget build(BuildContext context) {
    final glassFill = isDark
        ? AppColors.charcoalDark.withValues(alpha: 0.72)
        : AppColors.white.withValues(alpha: GlassTheme.fillOpacityStrong);
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.24)
        : GlassTheme.borderColor;
    final labelColor = isDark ? AppColors.white : AppColors.charcoal;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_scanMenuBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: GlassTheme.blur,
            sigmaY: GlassTheme.blur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: glassFill,
              borderRadius:
                  BorderRadius.circular(_scanMenuBorderRadius),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: GlassTheme.shadow,
            ),
            child: SizedBox(
              width: _scanMenuMinWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Obx(
                  () => SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => controller.setShowValidation(
                              !controller.showValidation.value,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Show Validation',
                                style: AppStyles.normalText.copyWith(
                                  color: labelColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SwitchTheme(
                          data: SwitchTheme.of(context).copyWith(
                            trackOutlineColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.transparent,
                            ),
                            trackColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primary.withValues(alpha: 0.45);
                                }
                                return isDark
                                    ? AppColors.white.withValues(alpha: 0.18)
                                    : AppColors.charcoal.withValues(alpha: 0.18);
                              },
                            ),
                            thumbColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primary;
                                }
                                return isDark
                                    ? AppColors.white.withValues(alpha: 0.82)
                                    : AppColors.charcoalLight;
                              },
                            ),
                          ),
                          child: Switch(
                            value: controller.showValidation.value,
                            onChanged: controller.setShowValidation,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
