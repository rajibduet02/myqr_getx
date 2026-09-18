import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../models/merchant_qr_tag26_institution_ids.dart';
import 'merchant_qr_tag26_sheet_theme.dart';

class MerchantQrTag26InstitutionIdField extends StatelessWidget {
  const MerchantQrTag26InstitutionIdField({
    super.key,
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = MerchantQrTag26InstitutionIds.findByCode(selectedCode);

    return MerchantQrTag26FieldGroup(
      tag: '02',
      label: 'Acquirer Institution ID',
      child: MerchantQrTag26SelectorField(
        placeholder: 'Select institution',
        primaryText: selected?.name,
        secondaryCode: selected?.code,
        onTap: () => _openPicker(context),
      ),
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: _MerchantQrTag26InstitutionIdPickerSheet(
            selectedCode: selectedCode,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}

class _MerchantQrTag26InstitutionIdPickerSheet extends StatefulWidget {
  const _MerchantQrTag26InstitutionIdPickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  State<_MerchantQrTag26InstitutionIdPickerSheet> createState() =>
      _MerchantQrTag26InstitutionIdPickerSheetState();
}

class _MerchantQrTag26InstitutionIdPickerSheetState
    extends State<_MerchantQrTag26InstitutionIdPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MerchantQrTag26InstitutionId> get _filteredItems {
    final query = _searchController.text;
    return MerchantQrTag26InstitutionIds.all
        .where((item) => item.matchesQuery(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.62;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(MerchantQrTag26SheetTheme.sheetRadius),
      ),
      child: Material(
        color: MerchantQrTag26SheetTheme.sheetBackground,
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MerchantQrTag26SheetHandle(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    MerchantQrTag26SheetTheme.horizontalPadding,
                    0,
                    MerchantQrTag26SheetTheme.horizontalPadding,
                    12,
                  ),
                  child: Text(
                    'Select Institution',
                    style: AppStyles.mediumText.copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MerchantQrTag26SheetTheme.horizontalPadding,
                  ),
                  child: Container(
                    decoration: MerchantQrTag26SheetTheme.fieldDecoration(),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: AppColors.primary,
                      style: AppStyles.formTextStyle,
                      decoration: MerchantQrTag26SheetTheme.inputDecoration(
                        hintText: 'Search institution...',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary.withValues(alpha: 0.75),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: MerchantQrTag26SheetTheme.divider),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item.code == widget.selectedCode;
                      return _MerchantInstitutionPickerRow(
                        code: item.code,
                        name: item.name,
                        isSelected: isSelected,
                        onTap: () {
                          widget.onSelected(item.code);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MerchantInstitutionPickerRow extends StatelessWidget {
  const _MerchantInstitutionPickerRow({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MerchantQrTag26SheetTheme.horizontalPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              MerchantQrTag26CodeBadge(code: code, compact: true),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: AppStyles.formTextStyle.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
