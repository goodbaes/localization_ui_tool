import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:localization_ui_tool/core/data/datasource/directory_datasource.dart';
import 'package:localization_ui_tool/core/errors/no_arb_files_found_exception.dart';
import 'package:path/path.dart' as p;

class FilePickerDirectoryDataSource implements DirectoryDatasource {
  @override
  Future<String?> selectDirectory() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    debugPrint('FilePickerDirectoryDataSource: Selected directory: $selectedDirectory');
    if (selectedDirectory != null) {
      final directory = Directory(selectedDirectory);
      final files = await directory.list().toList();
      final arbFiles = files.where((file) => file.path.endsWith('.arb')).toList();
      if (arbFiles.isEmpty) {
        debugPrint('FilePickerDirectoryDataSource: No ARB files found in $selectedDirectory');
        throw NoArbFilesFoundException();
      }
      debugPrint('FilePickerDirectoryDataSource: Found ARB files. Returning path: ${p.normalize(p.absolute(selectedDirectory))}');
      return p.normalize(p.absolute(selectedDirectory));
    }
    debugPrint('FilePickerDirectoryDataSource: No directory selected.');
    return null;
  }
}
