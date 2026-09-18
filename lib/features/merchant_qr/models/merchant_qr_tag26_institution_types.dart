import '../../../shared/models/recipient_institution_types.dart';

export '../../../shared/models/recipient_institution_types.dart';

typedef MerchantQrTag26InstitutionType = RecipientInstitutionType;

class MerchantQrTag26InstitutionTypes {
  MerchantQrTag26InstitutionTypes._();

  static List<MerchantQrTag26InstitutionType> get all =>
      RecipientInstitutionTypes.all;

  static MerchantQrTag26InstitutionType? findByCode(String? code) =>
      RecipientInstitutionTypes.findByCode(code);
}
