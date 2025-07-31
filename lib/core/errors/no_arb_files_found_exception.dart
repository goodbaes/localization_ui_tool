class NoArbFilesFoundException implements Exception {

  NoArbFilesFoundException([this.message = 'No .arb files found in the selected directory.']);
  final String message;

  @override
  String toString() => message;
}
