import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../models/merchant_qr_tag26_institution_types.dart';
import 'merchant_qr_tag26_sheet_theme.dart';

class MerchantQrTag26InstitutionTypeField extends StatelessWidget {
  const MerchantQrTag26InstitutionTypeField({
    super.key,
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = MerchantQrTag26InstitutionTypes.findByCode(selectedCode);

    return MerchantQrTag26FieldGroup(
      tag: '01',
      label: 'Acquirer Institution Type',
      child: MerchantQrTag26SelectorField(
        placeholder: 'Select institution type',
        primaryText: selected?.label,
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
          child: _MerchantQrTag26InstitutionTypePickerSheet(
            selectedCode: selectedCode,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}

class _MerchantQrTag26InstitutionTypePickerSheet extends StatefulWidget {
  const _MerchantQrTag26InstitutionTypePickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  State<_MerchantQrTag26InstitutionTypePickerSheet> createState() =>
      _MerchantQrTag26InstitutionTypePickerSheetState();
}

class _MerchantQrTag26InstitutionTypePickerSheetState
    extends State<_MerchantQrTag26InstitutionTypePickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MerchantQrTag26InstitutionType> get _filteredItems {
    final query = _searchController.text;
    return MerchantQrTag26InstitutionTypes.all
        .where((item) => item.matchesQuery(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.72;

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
                    'Select Institution Type',
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
                        hintText: 'Search institution type',
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
                      return _MerchantTypePickerRow(
                        code: item.code,
                        label: item.label,
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

class _MerchantTypePickerRow extends StatelessWidget {
  const _MerchantTypePickerRow({
    required this.code,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String label;
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
                  label,
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
