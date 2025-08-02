import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';

abstract class LocalizationRepository {
  Future<List<LocalizationEntry>> loadAll();
  Future<void> saveEntry(LocalizationEntry entry);
  Future<List<Locale>> getSupportedLocales();
  Future<bool> hasArbFiles(String directoryPath);
}
