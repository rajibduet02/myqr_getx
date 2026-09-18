import '../models/emv_field.dart';
import '../models/emv_spec.dart';
import '../models/emvco_spec_list.dart';

class EmvcoRepository {
  final EMVCOSpecList _specList = EMVCOSpecList();

  EMVCOSpecList get specList => _specList;

  EMVSpec getSpecByIndex(int index, String template) =>
      _specList.GetSpecByIndex(index, template);

  List<emvFileds> extractEmvcoInformation(String qrText, String template) {
    final emvFieldsAll = List<emvFileds>.generate(
      100,
      (_) => emvFileds('dm', 'dm', 'dm', const EMVSpec(
        Id: '',
        Name: '',
        Format: '',
        Length: '',
        Presence: '',
        Comments: '',
      )),
      growable: true,
    );

    int startIndex = 0;
    int endIndex = 2;
    final fullQrText = qrText;

    while (endIndex <= fullQrText.length) {
      final tag = fullQrText.substring(startIndex, endIndex);

      startIndex = endIndex;
      endIndex += 2;
      final length = fullQrText.substring(startIndex, endIndex);

      startIndex = endIndex;
      endIndex = startIndex + int.parse(length);
      final value = fullQrText.substring(startIndex, endIndex);
      startIndex = endIndex;
      endIndex = endIndex + 2;

      final specification = getSpecByIndex(int.parse(tag), template);

      emvFieldsAll[int.parse(tag)] =
          emvFileds(tag, length, value, specification);
    }

    return emvFieldsAll.where((element) => element.tag != 'dm').toList();
  }
}
