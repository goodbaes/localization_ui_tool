class NoArbFilesFoundException implements Exception {
  final String message;

  NoArbFilesFoundException([this.message = 'No .arb files found in the selected directory.']);

  @override
  String toString() => message;
}
