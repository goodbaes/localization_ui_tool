import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/utils/directory_access_validator.dart';
import 'package:localization_ui_tool/infrastructure/models/arb_parser.dart';
import 'package:path/path.dart' as path;

class ArbFileRepository implements LocalizationRepository {
  ArbFileRepository({
    required this.parser,
    required this.settingsRepository,
  });
  final ArbParser parser;
  final SettingsRepository settingsRepository;

  @override
  Future<List<LocalizationEntry>> loadAll() async {
    final directoryPath = await settingsRepository.directoryPath;
    if (directoryPath == null || directoryPath.isEmpty) {
      return [];
    }

    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return [];
    }

    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return [];
    }

    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return [];
    }

    List<File> files;
    try {
      files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList();
    } on FileSystemException catch (e) {
      debugPrint('Error listing files in directory $directoryPath: $e');
      return [];
    }

    final entriesMap = <String, Map<String, String>>{};
    final allKeys = <String>{};

    for (final file in files) {
      try {
        final content = await file.readAsString();
        final arbData = parser.parse(content);
        parser.collectKeysFromMap(arbData, '', allKeys);
      } catch (e) {
        debugPrint('Error reading or parsing ARB file ${file.path}: $e');
      }
    }

    for (final key in allKeys) {
      entriesMap[key] = {};
    }

    await Future.wait(files.map((file) async {
      try {
        final content = await file.readAsString();
        final arbData = parser.parse(content);
        final localeMatch =
            RegExp(r'_(\w{2})$').firstMatch(path.basenameWithoutExtension(file.path));
        final locale = localeMatch?.group(1);

        if (locale == null) return;

        for (final key in allKeys) {
          final value = _getValueFromNestedMap(arbData, key);
          if (value != null) {
            entriesMap[key]![locale] = value;
          }
        }
      } catch (e) {
        debugPrint('Error processing ARB file ${file.path}: $e');
      }
    }));

    return entriesMap.entries
        .map((e) => LocalizationEntry(key: e.key, values: e.value))
        .toList();
  }

  String? _getValueFromNestedMap(Map<String, dynamic> map, String key) {
    final parts = key.split('.');
    dynamic currentValue = map;
    for (final part in parts) {
      if (currentValue is Map<String, dynamic> &&
          currentValue.containsKey(part)) {
        currentValue = currentValue[part];
      } else {
        return null;
      }
    }
    return currentValue is String ? currentValue : null;
  }

  @override
  Future<void> saveEntry(LocalizationEntry entry) async {
    final directoryPath = await settingsRepository.directoryPath;
    if (directoryPath == null || directoryPath.isEmpty) {
      return;
    }
    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return;
    }

    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return;
    }

    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return;
    }
    Iterable<File> files;
    try {
      files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'));
    } on FileSystemException catch (e) {
      debugPrint('Error listing files in directory $directoryPath: $e');
      return;
    }

    for (final file in files) {
      final content = file.readAsStringSync();
      final arbData = parser.parse(content);
      final localeMatch =
          RegExp(r'_(\w{2})$').firstMatch(path.basenameWithoutExtension(file.path));
      final locale = localeMatch?.group(1);

      if (locale == null) continue;

      if (entry.values.containsKey(locale)) {
        final updatedArbData =
            parser.addValueToMap(arbData, entry.key, entry.values[locale]);
        file.writeAsStringSync(parser.serialize(updatedArbData));
      }
    }
  }

  static Future<bool> hasArbFiles(String directoryPath) async {
    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return false;
    }

    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return false;
    }

    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return false;
    }
    Iterable<File> files;
    try {
      files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'));
    } on FileSystemException catch (e) {
      debugPrint('Error listing files in directory $directoryPath: $e');
      return false;
    }
    return files.isNotEmpty;
  }

  @override
  Future<List<Locale>> getSupportedLocales() async {
    final directoryPath = await settingsRepository.directoryPath;
    if (directoryPath == null || directoryPath.isEmpty) {
      return [];
    }
    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return [];
    }

    if (!await DirectoryAccessValidator.isAccessible(directoryPath)) {
      debugPrint('Directory is not accessible: $directoryPath');
      return [];
    }

    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return [];
    }
    final locales = <Locale>{};
    try {
      final files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'));
      for (final file in files) {
        final fileName = path.basenameWithoutExtension(file.path);
        final match = RegExp(r'_(\w{2})$').firstMatch(fileName);
        if (match != null && match.group(1) != null) {
          locales.add(Locale(match.group(1)!));
        }
      }
    } on FileSystemException catch (e) {
      debugPrint('Error listing files in directory $directoryPath: $e');
    }
    return locales.toList();
  }
}