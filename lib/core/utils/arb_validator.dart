class ArbValidator {
  static String? validateKey(String? key) {
    if (key == null || key.isEmpty) {
      return 'Key cannot be empty.';
    }
    if (key.startsWith('@')) {
      return 'Key cannot start with "@".';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(key)) {
      return 'Key can only contain alphanumeric characters and underscores.';
    }
    return null; // Valid
  }

  static String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Translation cannot be empty.';
    }
    return null; // Valid
  }
}