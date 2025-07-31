import 'dart:convert';

class ArbParser {
  Map<String, dynamic> parse(String content) => json.decode(content) as Map<String, dynamic>;

  String serialize(Map<String, dynamic> jsonMap) =>
      const JsonEncoder.withIndent('  ').convert(jsonMap);

  void collectKeysFromMap(Map<String, dynamic> map, String prefix, Set<String> keys) {
    for (final entry in map.entries) {
      final key = entry.key;
      if (key.startsWith('@@')) continue;

      final value = entry.value;
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';

      if (value is Map<String, dynamic>) {
        collectKeysFromMap(value, fullKey, keys);
      } else {
        keys.add(fullKey);
      }
    }
  }

  Map<String, dynamic> addValueToMap(Map<String, dynamic> base, String key, dynamic value) {
    final parts = key.split('.');
    if (parts.isEmpty) return base;

    final newPart = _createNestedMap(parts, value);
    return _mergeMaps(base, parts, newPart);
  }

  Map<String, dynamic> _createNestedMap(List<String> parts, dynamic value) {
    if (parts.isEmpty) return {};
    if (parts.length == 1) return {parts[0]: value};
    final inner = _createNestedMap(parts.sublist(1), value);
    return {parts[0]: inner};
  }

  Map<String, dynamic> _mergeMaps(
    Map<String, dynamic> base,
    List<String> parts,
    Map<String, dynamic> newPart,
  ) {
    final result = Map<String, dynamic>.from(base);
    var current = result;
    for (var i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!current.containsKey(part) || current[part] is! Map<String, dynamic>) {
        current[part] = <String, dynamic>{};
      }
      current = current[part] as Map<String, dynamic>;
    }
    final last = parts.last;
    current[last] = newPart[last];
    return result;
  }
}