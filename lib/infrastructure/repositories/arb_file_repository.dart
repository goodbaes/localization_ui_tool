import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/infrastructure/models/arb_parser.dart';

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
    return compute(_parseAllFiles, {'path': directoryPath});
  }

  static List<LocalizationEntry> _parseAllFiles(Map<String, String> args) {
    final directory = Directory(args['path']!);
    if (!directory.existsSync()) {
      return [];
    }
    final files = directory.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.arb'),
    );

    final entriesMap = <String, Map<String, String>>{};

    for (final file in files) {
      final content = file.readAsStringSync();
      final arbData = json.decode(content) as Map<String, dynamic>;
      final locale = arbData['@@locale'] as String;

      arbData.forEach((key, value) {
        if (!key.startsWith('@@') && value is String) {
          entriesMap.putIfAbsent(key, () => {});
          entriesMap[key]![locale] = value;
        }
      });
    }

    return entriesMap.entries.map((e) => LocalizationEntry(key: e.key, values: e.value)).toList();
  }

  @override
  Future<void> saveEntry(LocalizationEntry entry) async {
    final directoryPath = await settingsRepository.directoryPath;
    if (directoryPath == null || directoryPath.isEmpty) {
      return;
    }
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return;
    }
    final files = directory.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.arb'),
    );

    for (final file in files) {
      final content = file.readAsStringSync();
      final arbData = json.decode(content) as Map<String, dynamic>;
      final locale = arbData['@@locale'] as String;

      if (entry.values.containsKey(locale)) {
        arbData[entry.key] = entry.values[locale];
        file.writeAsStringSync(parser.serialize(arbData));
      }
    }
  }

  static Future<bool> hasArbFiles(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return false;
    }
    final files = directory.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.arb'),
    );
    return files.isNotEmpty;
  }

  @override
  @override
  Future<List<Locale>> getSupportedLocales() async {
    final directoryPath = await settingsRepository.directoryPath;
    if (directoryPath == null || directoryPath.isEmpty) {
      return [];
    }
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return [];
    }
    final files = directory.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.arb'),
    );

    final locales = <Locale>{};
    for (final file in files) {
      try {
        final content = file.readAsStringSync();
        final arbData = json.decode(content) as Map<String, dynamic>;
        final localeString = arbData['@@locale'] as String?;
        if (localeString != null && localeString.isNotEmpty) {
          locales.add(Locale(localeString));
        }
      } catch (e) {
        // Log error or handle corrupted ARB file
        debugPrint('Error parsing ARB file ${file.path}: $e');
      }
    }
    return locales.toList();
  }
}
