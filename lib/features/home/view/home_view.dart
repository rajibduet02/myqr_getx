import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_scaffold.dart';
import '../../generate/view/generate_view.dart';
import '../../knowledge_base/view/knowledge_base_view.dart';
import '../../scan/controller/scan_controller.dart';
import '../../scan/view/scan_view.dart';
import '../../scan/widgets/scan_glass_options_menu.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeTabScaffold();
  }
}

class _HomeTabScaffold extends StatefulWidget {
  const _HomeTabScaffold();

  @override
  State<_HomeTabScaffold> createState() => _HomeTabScaffoldState();
}

class _HomeTabScaffoldState extends State<_HomeTabScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanController = Get.find<ScanController>();

    return GlassScaffold(
      appBar: GlassAppBar.build(
        title: const Text('AttoQR', style: AppStyles.appBarText),
        actions: [
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              if (_tabController.index != 0) {
                return const SizedBox.shrink();
              }

              return ScanGlassOptionsMenu(controller: scanController);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_scanner_outlined), text: 'Scan'),
            Tab(icon: Icon(Icons.create_outlined), text: 'Generate'),
            Tab(icon: Icon(Icons.help_center_sharp), text: 'Knowledge Base'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ScanView(),
          GenerateView(),
          KnowledgeBaseView(),
        ],
      ),
    );
  }
}
