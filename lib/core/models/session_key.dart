enum SessionKeyStatus {
  newKey,
  modifiedKey,
}

class SessionKey {
  final String key;
  final SessionKeyStatus status;

  SessionKey({required this.key, required this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionKey && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}