import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/models/emv_spec.dart';
import '../../../shared/repositories/emvco_repository.dart';
import '../../../shared/widgets/card_component.dart';

class KnowledgeBaseController extends GetxController {
  final EmvcoRepository _repository = EmvcoRepository();
  final searchController = TextEditingController();

  final fieldDetails = <EMVSpec>[].obs;
  final tempFieldDetails = <EMVSpec>[].obs;

  @override
  void onInit() {
    super.onInit();
    fieldDetails.assignAll(_repository.specList.SpecList);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchController.text = '';
    fieldDetails.assignAll(tempFieldDetails);
  }

  void searchList(String query) {
    if (tempFieldDetails.isEmpty) {
      tempFieldDetails.assignAll(fieldDetails);
    }

    if (searchController.text.isNotEmpty) {
      final results = tempFieldDetails.where((element) {
        return element.Id.toUpperCase().contains(query.toUpperCase()) ||
            element.Name.toUpperCase().contains(query.toUpperCase()) ||
            element.Comments.toUpperCase().contains(query.toUpperCase());
      }).toList();

      if (results.isNotEmpty) {
        fieldDetails.assignAll(results);
      } else {
        Fluttertoast.showToast(
          msg: "Search text didn't match anything.Showing Last Search result.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      fieldDetails.assignAll(tempFieldDetails);
    }
  }
}
