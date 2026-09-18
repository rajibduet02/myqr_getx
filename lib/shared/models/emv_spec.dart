class EMVSpec {
  final String Id;
  final String Name;
  final String Format;
  final String Length;
  final String Presence;
  final String Comments;

  const EMVSpec({
    required this.Id,
    required this.Name,
    required this.Format,
    required this.Length,
    required this.Presence,
    required this.Comments,
  });

  factory EMVSpec.fromJson(Map<String, dynamic> json) => EMVSpec(
        Id: json['Id'] as String? ?? '',
        Name: json['Name'] as String? ?? '',
        Format: json['Format'] as String? ?? '',
        Length: json['Length'] as String? ?? '',
        Presence: json['Presence'] as String? ?? '',
        Comments: json['Comments'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'Name': Name,
        'Format': Format,
        'Length': Length,
        'Presence': Presence,
        'Comments': Comments,
      };

  EMVSpec copyWith({
    String? Id,
    String? Name,
    String? Format,
    String? Length,
    String? Presence,
    String? Comments,
  }) =>
      EMVSpec(
        Id: Id ?? this.Id,
        Name: Name ?? this.Name,
        Format: Format ?? this.Format,
        Length: Length ?? this.Length,
        Presence: Presence ?? this.Presence,
        Comments: Comments ?? this.Comments,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EMVSpec && runtimeType == other.runtimeType && Id == other.Id;

  @override
  int get hashCode => Id.hashCode;
}
