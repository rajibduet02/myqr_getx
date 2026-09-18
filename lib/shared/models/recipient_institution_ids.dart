class RecipientInstitutionId {
  const RecipientInstitutionId({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  String get displayText => '$code - $name';

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return code.contains(normalized) ||
        name.toLowerCase().contains(normalized) ||
        displayText.toLowerCase().contains(normalized);
  }
}

class RecipientInstitutionIds {
  RecipientInstitutionIds._();

  static const List<RecipientInstitutionId> all = [
    RecipientInstitutionId(code: '0060', name: 'BRAC Bank PLC'),
    RecipientInstitutionId(code: '0085', name: 'Dhaka Bank PLC'),
    RecipientInstitutionId(code: '0095', name: 'Eastern Bank PLC'),
    RecipientInstitutionId(code: '0170', name: 'Prime Bank PLC'),
    RecipientInstitutionId(code: '0275', name: 'Meghna Bank PLC'),
  ];

  static RecipientInstitutionId? findByCode(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final item in all) {
      if (item.code == code) return item;
    }
    return null;
  }
}
