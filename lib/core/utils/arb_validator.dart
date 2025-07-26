import 'package:flutter/material.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class ArbValidator {
  /// Возвращает текст ошибки или null, если всё ок.
  static String? validateKey(BuildContext context, String? key) {
    final l10n = context.l10n;
    if (key == null || key.isEmpty) {
      return l10n.keyCannotBeEmpty;
    }
    if (key.startsWith('@')) {
      return l10n.keyCannotStartWithAt;
    }
    if (!RegExp(r'^[a-zA-Z_]+$').hasMatch(key)) {
      return l10n.keyInvalidCharacters;
    }
    return null;
  }

  static String? validateValue(BuildContext context, String? value) {
    final l10n = context.l10n;
    if (value == null || value.isEmpty) {
      return l10n.translationCannotBeEmpty;
    }
    return null;
  }
}
