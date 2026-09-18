import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../models/client_qr_tag26_institution_ids.dart';
import 'client_qr_tag26_sheet_theme.dart';

class ClientQrTag26InstitutionIdField extends StatelessWidget {
  const ClientQrTag26InstitutionIdField({
    super.key,
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = ClientQrTag26InstitutionIds.findByCode(selectedCode);

    return ClientQrTag26FieldGroup(
      tag: '02',
      label: 'Recipients Institution ID',
      child: ClientQrTag26SelectorField(
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
          child: _ClientQrTag26InstitutionIdPickerSheet(
            selectedCode: selectedCode,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}

class _ClientQrTag26InstitutionIdPickerSheet extends StatefulWidget {
  const _ClientQrTag26InstitutionIdPickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  State<_ClientQrTag26InstitutionIdPickerSheet> createState() =>
      _ClientQrTag26InstitutionIdPickerSheetState();
}

class _ClientQrTag26InstitutionIdPickerSheetState
    extends State<_ClientQrTag26InstitutionIdPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClientQrTag26InstitutionId> get _filteredItems {
    final query = _searchController.text;
    return ClientQrTag26InstitutionIds.all
        .where((item) => item.matchesQuery(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.62;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(ClientQrTag26SheetTheme.sheetRadius),
      ),
      child: Material(
        color: ClientQrTag26SheetTheme.sheetBackground,
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ClientQrTag26SheetHandle(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ClientQrTag26SheetTheme.horizontalPadding,
                    0,
                    ClientQrTag26SheetTheme.horizontalPadding,
                    12,
                  ),
                  child: Text(
                    'Select Institution',
                    style: AppStyles.mediumText.copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ClientQrTag26SheetTheme.horizontalPadding,
                  ),
                  child: Container(
                    decoration: ClientQrTag26SheetTheme.fieldDecoration(),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: AppColors.primary,
                      style: AppStyles.formTextStyle,
                      decoration: ClientQrTag26SheetTheme.inputDecoration(
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
                const Divider(height: 1, color: ClientQrTag26SheetTheme.divider),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item.code == widget.selectedCode;
                      return _InstitutionPickerRow(
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

class _InstitutionPickerRow extends StatelessWidget {
  const _InstitutionPickerRow({
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
            horizontal: ClientQrTag26SheetTheme.horizontalPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              ClientQrTag26CodeBadge(code: code, compact: true),
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
                Icon(
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
