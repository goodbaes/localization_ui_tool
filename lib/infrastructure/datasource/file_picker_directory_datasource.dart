import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:localization_ui_tool/core/data/datasource/directory_datasource.dart';
import 'package:localization_ui_tool/core/errors/no_arb_files_found_exception.dart';
import 'package:path/path.dart' as p;

class FilePickerDirectoryDataSource implements DirectoryDatasource {
  @override
  Future<String?> selectDirectory() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final directory = Directory(selectedDirectory);
      final files = await directory.list().toList();
      final arbFiles = files.where((file) => file.path.endsWith('.arb')).toList();
      if (arbFiles.isEmpty) {
        throw NoArbFilesFoundException();
      }
      return p.normalize(p.absolute(selectedDirectory));
    }
    return null;
  }
}
