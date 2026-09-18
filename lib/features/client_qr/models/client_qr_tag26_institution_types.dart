import '../../../shared/models/recipient_institution_types.dart';

export '../../../shared/models/recipient_institution_types.dart';

typedef ClientQrTag26InstitutionType = RecipientInstitutionType;

class ClientQrTag26InstitutionTypes {
  ClientQrTag26InstitutionTypes._();

  static List<ClientQrTag26InstitutionType> get all => RecipientInstitutionTypes.all;

  static ClientQrTag26InstitutionType? findByCode(String? code) =>
      RecipientInstitutionTypes.findByCode(code);
}
