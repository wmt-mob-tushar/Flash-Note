class ApiExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  ApiExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class NoInternetException extends ApiExceptions {
  NoInternetException(String message) : super(message, "");
}
