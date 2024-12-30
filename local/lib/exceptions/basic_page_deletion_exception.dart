class BasicPageDeletionException implements Exception {
  final String message;

  BasicPageDeletionException([this.message = 'Cannot delete the basic page.']);

  @override
  String toString() => 'BasicPageDeletionException: $message';
}
