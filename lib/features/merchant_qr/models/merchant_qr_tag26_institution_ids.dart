import '../../../shared/models/recipient_institution_ids.dart';

export '../../../shared/models/recipient_institution_ids.dart';

typedef MerchantQrTag26InstitutionId = RecipientInstitutionId;

class MerchantQrTag26InstitutionIds {
  MerchantQrTag26InstitutionIds._();

  static List<MerchantQrTag26InstitutionId> get all =>
      RecipientInstitutionIds.all;

  static MerchantQrTag26InstitutionId? findByCode(String? code) =>
      RecipientInstitutionIds.findByCode(code);
}
