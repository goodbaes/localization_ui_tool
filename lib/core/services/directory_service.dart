import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:localization_ui_tool/core/data/datasource/directory_datasource.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:rxdart/subjects.dart';

class DirectoryService {
  DirectoryService(this._settingsRepository, this._directoryRepository) {
    _init();
  }
  final DirectoryDatasource _directoryRepository;
  final SettingsRepository _settingsRepository;
  final BehaviorSubject<String?> _directoryPathSubject = BehaviorSubject<String?>.seeded(null);

  Stream<String?> get directoryPathStream => _directoryPathSubject.stream;
  String? _currentDirectoryPath;

  String? get currentDirectoryPath => _currentDirectoryPath;

  Future<void> _init() async {
    _currentDirectoryPath = await _settingsRepository.directoryPath;
    _directoryPathSubject.add(_currentDirectoryPath);
  }

  Future<String?> selectDirectory() async {
    debugPrint('DirectoryService: Attempting to select directory.');
    final selectedDirectory = await _directoryRepository.selectDirectory();
    if (selectedDirectory != null) {
      debugPrint('DirectoryService: Directory selected: $selectedDirectory. Saving path.');
      await setDirectoryPath(selectedDirectory);
      return selectedDirectory;
    } else {
      debugPrint('DirectoryService: No directory selected by user.');
      throw Exception('No directory selected');
    }
  }

  Future<void> setDirectoryPath(String? path) async {
    debugPrint('DirectoryService: Setting directory path to: $path');
    _currentDirectoryPath = path;
    await _settingsRepository.setDirectoryPath(path ?? ''); // Save to settings
    _directoryPathSubject.add(path); // Emit the new path
    debugPrint('DirectoryService: Directory path set and emitted.');
  }

  void dispose() {
    _directoryPathSubject.close();
  }
}
