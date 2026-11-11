sealed class AppFailure {
  const AppFailure(this.message, {this.code});
  final String message;
  final String? code;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network error', String? code]) : super(code: code);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Please sign in again']) : super(code: 'UNAUTHORIZED');
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {super.code});
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
