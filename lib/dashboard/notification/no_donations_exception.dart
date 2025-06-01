// lib/exceptions/no_donations_exception.dart
class NoDonationsFoundException implements Exception {
  final String message;

  const NoDonationsFoundException([this.message = 'No donations found.']);

  @override
  String toString() {
    return 'NoDonationsFoundException: $message';
  }
}
