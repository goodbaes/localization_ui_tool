import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';

class GetSupportedLocalesUseCase {
  GetSupportedLocalesUseCase(this.localizationRepository);
  final LocalizationRepository localizationRepository;

  Future<List<Locale>> call() async {
    return localizationRepository.getSupportedLocales();
  }
}
