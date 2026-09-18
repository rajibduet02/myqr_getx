import 'emv_spec.dart';

class emvFileds {
  String tag;
  String length;
  String value;
  EMVSpec specification;

  emvFileds(this.tag, this.length, this.value, this.specification);

  factory emvFileds.fromJson(Map<String, dynamic> json) => emvFileds(
        json['tag'] as String? ?? '',
        json['length'] as String? ?? '',
        json['value'] as String? ?? '',
        EMVSpec.fromJson(json['specification'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'length': length,
        'value': value,
        'specification': specification.toJson(),
      };

  emvFileds copyWith({
    String? tag,
    String? length,
    String? value,
    EMVSpec? specification,
  }) =>
      emvFileds(
        tag ?? this.tag,
        length ?? this.length,
        value ?? this.value,
        specification ?? this.specification,
      );
}
