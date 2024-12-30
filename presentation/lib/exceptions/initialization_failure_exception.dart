class InitializationFailureException implements Exception {
  final String message;

  InitializationFailureException([this.message = 'Cannot initialize the basic page.']);

  @override
  String toString() => 'InitializationFailureException: $message';
}
