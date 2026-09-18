import '../../../shared/models/recipient_institution_ids.dart';

export '../../../shared/models/recipient_institution_ids.dart';

typedef ClientQrTag26InstitutionId = RecipientInstitutionId;

class ClientQrTag26InstitutionIds {
  ClientQrTag26InstitutionIds._();

  static List<ClientQrTag26InstitutionId> get all => RecipientInstitutionIds.all;

  static ClientQrTag26InstitutionId? findByCode(String? code) =>
      RecipientInstitutionIds.findByCode(code);
}
