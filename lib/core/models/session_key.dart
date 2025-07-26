import 'dart:core';

enum SessionKeyStatus { newKey, modifiedKey }

class SessionKey {
  SessionKey({required this.key, required this.status});

  factory SessionKey.fromJson(Map<String, dynamic> json) {
    return SessionKey(
      key: json['key'] as String,
      status: SessionKeyStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SessionKeyStatus.newKey,
      ),
    );
  }
  final String key;
  final SessionKeyStatus status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionKey && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'status': status.name,
    };
  }
}
