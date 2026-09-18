class RecipientInstitutionType {
  const RecipientInstitutionType({
    required this.code,
    required this.label,
  });

  final String code;
  final String label;

  String get displayText => '$code - $label';

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return code.contains(normalized) ||
        label.toLowerCase().contains(normalized) ||
        displayText.toLowerCase().contains(normalized);
  }
}

class RecipientInstitutionTypes {
  RecipientInstitutionTypes._();

  static const _labels = <String, String>{
    '00': 'Banks',
    '01': 'NBFI',
    '02': 'MFS',
    '03': 'PSP',
    '04': 'PSO',
    '05': 'White Label ATM and/or Recipient Acquirer',
  };

  static final List<RecipientInstitutionType> all = List.generate(
    100,
    (index) {
      final code = index.toString().padLeft(2, '0');
      return RecipientInstitutionType(
        code: code,
        label: _labels[code] ?? 'RFU',
      );
    },
  );

  static RecipientInstitutionType? findByCode(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final item in all) {
      if (item.code == code) return item;
    }
    return null;
  }
}
