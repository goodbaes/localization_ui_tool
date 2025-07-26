import 'dart:async';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';

class DirectoryService {
  DirectoryService(this._settingsRepository) {
    _init();
  }

  final SettingsRepository _settingsRepository;
  final StreamController<String?> _directoryPathController = StreamController<String?>.broadcast();

  Stream<String?> get directoryPathStream => _directoryPathController.stream;
  String? _currentDirectoryPath;

  String? get currentDirectoryPath => _currentDirectoryPath;

  Future<void> _init() async {
    _currentDirectoryPath = await _settingsRepository.directoryPath;
    _directoryPathController.add(_currentDirectoryPath);
  }

  Future<void> setDirectoryPath(String? path) async {
    _currentDirectoryPath = path;
    await _settingsRepository.setDirectoryPath(path ?? ''); // Save to settings
    _directoryPathController.add(path); // Emit the new path
  }

  void dispose() {
    _directoryPathController.close();
  }
}
