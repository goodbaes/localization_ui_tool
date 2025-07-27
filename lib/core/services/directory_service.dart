import 'dart:async';
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

  Future<void> selectDirectory() async {
    final selectedDirectory = await _directoryRepository.selectDirectory();
    if (selectedDirectory != null) {
      await setDirectoryPath(selectedDirectory);
    } else {
      throw Exception('No directory selected');
    }
  }

  Future<void> setDirectoryPath(String? path) async {
    _currentDirectoryPath = path;
    await _settingsRepository.setDirectoryPath(path ?? ''); // Save to settings
    _directoryPathSubject.add(path); // Emit the new path
  }

  void dispose() {
    _directoryPathSubject.close();
  }
}
