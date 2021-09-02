class AWSException implements Exception {
  final String message;

  AWSException(this.message);

  @override
  String toString() => "AWSException($message)";
}

class AWSParameterNotFoundException extends AWSException {
  AWSParameterNotFoundException(String message) : super(message);
}

class AWSAccessDeniedException extends AWSException {
  AWSAccessDeniedException(String message) : super(message);
}

class AWSBinaryNotFoundException extends AWSException {
  AWSBinaryNotFoundException(String message) : super(message);
}
