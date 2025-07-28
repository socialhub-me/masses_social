/// Base exception class for Masses Social app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';
}

/// RSS-related exceptions
class RSSException extends AppException {
  const RSSException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'RSSException: $message';
}

/// Firebase-related exceptions
class FirebaseException extends AppException {
  const FirebaseException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'FirebaseException: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'AuthException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'NetworkException: $message';
}
