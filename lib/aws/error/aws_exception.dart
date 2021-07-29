import 'dart:io';

class AWSException implements Exception {
  final String message;

  AWSException(this.message);
}

class AWSParameterNotFoundException extends AWSException {
  AWSParameterNotFoundException(String message) : super(message);
}

class AWSAccessDeniedException extends AWSException {
  AWSAccessDeniedException(String message) : super(message);
}

class AWSBinaryNotFoundException extends AWSException {
  AWSBinaryNotFoundException.atLocation(String location) : super("Binary not found at $location");

  AWSBinaryNotFoundException.fromMultipleLocations(List<String> locations) : super("Binary not found at ${locations.join(",")}");
}

class AWSPlatformNotSupportedException extends AWSException {
  AWSPlatformNotSupportedException() : super("Platform ${Platform.operatingSystem} not supported");
}
