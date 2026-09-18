import 'package:flutter/material.dart';

import 'glass_background.dart';

class GlassScaffold extends StatelessWidget {
  const GlassScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.primary = true,
    this.extendBodyBehindAppBar = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final bool primary;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const GlassBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: extendBodyBehindAppBar && appBar != null,
          appBar: appBar,
          primary: primary,
          body: body,
          floatingActionButton: floatingActionButton,
        ),
      ],
    );
  }
}
