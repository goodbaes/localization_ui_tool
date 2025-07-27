import 'dart:io';
import 'package:flutter/foundation.dart';

class DirectoryAccessValidator {
  /// Проверяет, существует ли директория и доступна ли для чтения
  static Future<bool> isAccessible(String? path) async {
    if (path == null || path.isEmpty) return false;

    try {
      final dir = Directory(path);
      if (!await dir.exists()) return false;

      // Попытка чтения содержимого
      final contents = await dir.list().toList();
      return contents.isNotEmpty || contents.isEmpty; // Просто факт доступа
    } on FileSystemException catch (e) {
      debugPrint('DirectoryAccessValidator: FileSystemException - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('DirectoryAccessValidator: Unexpected error - $e');
      return false;
    }
  }
}
