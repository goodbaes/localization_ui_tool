import 'dart:convert';

class ArbParser {
  Map<String, dynamic> parse(String content) => json.decode(content) as Map<String, dynamic>;
  String serialize(Map<String, dynamic> jsonMap) =>
      const JsonEncoder.withIndent('  ').convert(jsonMap);
}
