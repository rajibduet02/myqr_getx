import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/glass_theme.dart';
import '../../../shared/widgets/card_component.dart';
import '../../../shared/widgets/glass_container.dart';
import '../controller/knowledge_base_controller.dart';

class KnowledgeBaseView extends StatelessWidget {
  const KnowledgeBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KnowledgeBaseController());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: GlassContainer(
            strong: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            borderRadius: GlassTheme.borderRadiusSmall,
            child: TextField(
              controller: controller.searchController,
              cursorColor: AppColors.primary,
              style: AppStyles.normalText,
              decoration: GlassTheme.searchDecoration(
                labelText: 'Search Fields',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: controller.searchController.text.isNotEmpty
                      ? const Icon(Icons.clear, color: AppColors.primary)
                      : const Icon(Icons.circle, color: Colors.transparent, size: 0),
                  onPressed: controller.clearSearch,
                ),
              ),
              onChanged: controller.searchList,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GlassContainer(
              strong: true,
              padding: const EdgeInsets.all(4),
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.fieldDetails.length,
                  itemBuilder: (context, index) {
                    final field = controller.fieldDetails[index];
                    return CardComponent(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              ' ${field.Id} - ${field.Name.toUpperCase()}',
                              style: AppStyles.mediumText,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Format  : ${field.Format}', style: AppStyles.normalText),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text('Length  : ${field.Length}', style: AppStyles.normalText),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text('Presence  : ${field.Presence}', style: AppStyles.normalText),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('-------', style: AppStyles.normalText),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Field Description :  ${field.Comments}',
                              style: AppStyles.normalText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
