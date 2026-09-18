import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/models/recipient_institution_ids.dart';
import '../../../shared/models/recipient_institution_types.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../client_qr/widgets/client_qr_tag26_sheet_theme.dart';
import '../services/emvco_private_key_storage_service.dart';

void showGenerateKeysBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: const _GenerateKeysBottomSheet(),
      );
    },
  );
}

class _GenerateKeysBottomSheet extends StatefulWidget {
  const _GenerateKeysBottomSheet();

  @override
  State<_GenerateKeysBottomSheet> createState() => _GenerateKeysBottomSheetState();
}

class _GenerateKeysBottomSheetState extends State<_GenerateKeysBottomSheet> {
  String? _selectedInstitutionTypeCode;
  String? _selectedInstitutionIdCode;
  final _privateKeyStorageService = EmvcoPrivateKeyStorageService();
  bool _isGeneratingPrivateKey = false;
  bool _isGeneratingPublicKey = false;

  bool get _isBusy => _isGeneratingPrivateKey || _isGeneratingPublicKey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(ClientQrTag26SheetTheme.sheetRadius),
      ),
      child: Material(
        color: ClientQrTag26SheetTheme.sheetBackground,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ClientQrTag26SheetHandle(),
                ClientQrBottomSheetHeader(
                  title: 'Generate Keys',
                  subtitle: 'Select the recipient institution details',
                  onClose: Get.back,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ClientQrTag26SheetTheme.horizontalPadding,
                    ClientQrTag26SheetTheme.headerToFields,
                    ClientQrTag26SheetTheme.horizontalPadding,
                    8,
                  ),
                  child: Column(
                    children: [
                      _InstitutionTypeSelector(
                        selectedCode: _selectedInstitutionTypeCode,
                        onSelected: (code) {
                          setState(() => _selectedInstitutionTypeCode = code);
                        },
                      ),
                      const SizedBox(height: ClientQrTag26SheetTheme.fieldGap),
                      _InstitutionIdSelector(
                        selectedCode: _selectedInstitutionIdCode,
                        onSelected: (code) {
                          setState(() => _selectedInstitutionIdCode = code);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ClientQrTag26SheetTheme.horizontalPadding,
                    ClientQrTag26SheetTheme.actionGap,
                    ClientQrTag26SheetTheme.horizontalPadding,
                    8,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: ClientQrTag26SheetTheme.buttonHeight,
                        child: ElevatedButton(
                          style: AppStyles.primaryButtonStyle.copyWith(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ClientQrTag26SheetTheme.fieldRadius,
                                ),
                              ),
                            ),
                          ),
                          onPressed: _isBusy ? null : _onPrivateKey,
                          child: _isGeneratingPrivateKey
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Private Key', style: AppStyles.buttonText),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: ClientQrTag26SheetTheme.buttonHeight,
                        child: ElevatedButton(
                          style: AppStyles.secondaryButtonStyle.copyWith(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ClientQrTag26SheetTheme.fieldRadius,
                                ),
                              ),
                            ),
                          ),
                          onPressed: _isBusy ? null : _onPublicKey,
                          child: _isGeneratingPublicKey
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Public Key', style: AppStyles.buttonText),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _isBusy ? null : Get.back,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.charcoalLight,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppStyles.formTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoalLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showKeyMessage(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  bool _validateInstitutionSelection() {
    final institutionTypeCode = _selectedInstitutionTypeCode;
    if (institutionTypeCode == null || institutionTypeCode.isEmpty) {
      _showKeyMessage('Please select a Recipient Institution Type.');
      return false;
    }

    final institutionIdCode = _selectedInstitutionIdCode;
    if (institutionIdCode == null || institutionIdCode.isEmpty) {
      _showKeyMessage('Please select a Recipient Institution ID.');
      return false;
    }

    return true;
  }

  Future<void> _generatePrivateKeyForSelection({
    bool showSuccessMessage = true,
  }) async {
    final institutionTypeCode = _selectedInstitutionTypeCode!;
    final institutionIdCode = _selectedInstitutionIdCode!;

    final result = await _privateKeyStorageService.generateAndStorePrivateKey(
      institutionTypeCode: institutionTypeCode,
      institutionIdCode: institutionIdCode,
    );

    if (showSuccessMessage && mounted) {
      _showKeyMessage(
        'Private key generated successfully and stored securely.\n'
        'Key ID: ${result.keyId}',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _onPrivateKey() async {
    if (!_validateInstitutionSelection()) {
      return;
    }

    setState(() => _isGeneratingPrivateKey = true);
    try {
      await _generatePrivateKeyForSelection();
    } on EmvcoPrivateKeyAlreadyExistsException {
      if (!mounted) return;
      _showKeyMessage(
        'A private key already exists for this institution.',
      );
    } catch (_) {
      if (!mounted) return;
      _showKeyMessage('Failed to generate private key');
    } finally {
      if (mounted) setState(() => _isGeneratingPrivateKey = false);
    }
  }

  Future<bool?> _showMissingPrivateKeyDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        content: GlassContainer(
          strong: true,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'No private key exists for this institution.',
                style: AppStyles.mediumText.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'A private key must be generated before the public key '
                'can be created.',
                style: AppStyles.formTextStyle.copyWith(height: 1.45),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Generate Private Key now?',
                style: AppStyles.formTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text(
                        'Cancel',
                        style: AppStyles.formTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoalLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: AppStyles.primaryButtonStyle,
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text(
                        'Generate Private Key',
                        style: AppStyles.buttonText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPublicKey() async {
    if (!_validateInstitutionSelection()) {
      return;
    }

    final institutionTypeCode = _selectedInstitutionTypeCode!;
    final institutionIdCode = _selectedInstitutionIdCode!;

    setState(() => _isGeneratingPublicKey = true);
    try {
      final hasPrivateKey = await _privateKeyStorageService.hasPrivateKey(
        institutionTypeCode: institutionTypeCode,
        institutionIdCode: institutionIdCode,
      );

      if (!hasPrivateKey) {
        if (!mounted) return;
        setState(() => _isGeneratingPublicKey = false);
        final shouldGeneratePrivateKey = await _showMissingPrivateKeyDialog();
        if (shouldGeneratePrivateKey != true || !mounted) {
          return;
        }

        setState(() => _isGeneratingPublicKey = true);
        try {
          await _generatePrivateKeyForSelection(showSuccessMessage: false);
        } on EmvcoPrivateKeyAlreadyExistsException {
          // Another process may have created the key; continue with public key.
        } catch (_) {
          if (!mounted) return;
          _showKeyMessage('Failed to generate private key');
          return;
        }
      }

      final result = await _privateKeyStorageService.deriveAndStorePublicKey(
        institutionTypeCode: institutionTypeCode,
        institutionIdCode: institutionIdCode,
      );
      if (!mounted) return;
      _showKeyMessage(
        'Public key generated successfully.\n'
        'Key ID: ${result.keyId}\n'
        'The public key has been securely associated with the existing private key.',
        toastLength: Toast.LENGTH_LONG,
      );
    } on EmvcoPublicKeyAlreadyExistsException {
      if (!mounted) return;
      _showKeyMessage('Public key already exists for this institution.');
    } catch (_) {
      if (!mounted) return;
      _showKeyMessage('Failed to generate public key');
    } finally {
      if (mounted) setState(() => _isGeneratingPublicKey = false);
    }
  }
}

class _InstitutionTypeSelector extends StatelessWidget {
  const _InstitutionTypeSelector({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = RecipientInstitutionTypes.findByCode(selectedCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipients Institution Type',
          style: AppStyles.formTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: ClientQrTag26SheetTheme.labelGap),
        ClientQrTag26SelectorField(
          placeholder: 'Select institution type',
          primaryText: selected?.label,
          secondaryCode: selected?.code,
          onTap: () => _openPicker(context),
        ),
      ],
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
          child: _InstitutionTypePickerSheet(
            selectedCode: selectedCode,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}

class _InstitutionIdSelector extends StatelessWidget {
  const _InstitutionIdSelector({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = RecipientInstitutionIds.findByCode(selectedCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipients Institution ID',
          style: AppStyles.formTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: ClientQrTag26SheetTheme.labelGap),
        ClientQrTag26SelectorField(
          placeholder: 'Select institution',
          primaryText: selected?.name,
          secondaryCode: selected?.code,
          onTap: () => _openPicker(context),
        ),
      ],
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
          child: _InstitutionIdPickerSheet(
            selectedCode: selectedCode,
            onSelected: onSelected,
          ),
        );
      },
    );
  }
}

class _InstitutionTypePickerSheet extends StatefulWidget {
  const _InstitutionTypePickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  State<_InstitutionTypePickerSheet> createState() => _InstitutionTypePickerSheetState();
}

class _InstitutionTypePickerSheetState extends State<_InstitutionTypePickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecipientInstitutionType> get _filteredItems {
    final query = _searchController.text;
    return RecipientInstitutionTypes.all
        .where((item) => item.matchesQuery(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.72;

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
                    'Select Institution Type',
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
                const Divider(height: 1, color: ClientQrTag26SheetTheme.divider),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item.code == widget.selectedCode;
                      return _PickerRow(
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

class _InstitutionIdPickerSheet extends StatefulWidget {
  const _InstitutionIdPickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  State<_InstitutionIdPickerSheet> createState() => _InstitutionIdPickerSheetState();
}

class _InstitutionIdPickerSheetState extends State<_InstitutionIdPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecipientInstitutionId> get _filteredItems {
    final query = _searchController.text;
    return RecipientInstitutionIds.all
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
                      return _PickerRow(
                        code: item.code,
                        label: item.name,
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

class _PickerRow extends StatelessWidget {
  const _PickerRow({
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
            horizontal: ClientQrTag26SheetTheme.horizontalPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              ClientQrTag26CodeBadge(code: code, compact: true),
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
