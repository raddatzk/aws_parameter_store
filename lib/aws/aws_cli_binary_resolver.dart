import 'dart:io';

import 'error/aws_exception.dart';

abstract class AWSCliBinaryResolver {
  String resolveBinaryLocation();
}

class AutomaticAWSCliBinaryResolver implements AWSCliBinaryResolver {
  @override
  String resolveBinaryLocation() {
    if (Platform.isMacOS) return AWSCliBinaryMacResolver().resolveBinaryLocation();
    throw AWSPlatformNotSupportedException();
  }
}

abstract class AbstractAWSCliBinaryResolver implements AWSCliBinaryResolver {
  List<String> get possibleLocations;

  @override
  String resolveBinaryLocation() {
    try {
      return possibleLocations.firstWhere((location) => File(location).existsSync());
    } on StateError {
      throw AWSBinaryNotFoundException.fromMultipleLocations(possibleLocations);
    }
  }
}

class AWSCliBinaryMacResolver extends AbstractAWSCliBinaryResolver {
  @override
  List<String> possibleLocations = ["/usr/local/bin/aws"];
}

class AWSCliBinaryMultiResolver {
  String? _location;

  String get location => _location ?? AutomaticAWSCliBinaryResolver().resolveBinaryLocation();

  set location(String location) {
    if (File(location).existsSync()) {
      _location = location;
    } else {
      throw AWSBinaryNotFoundException.atLocation(location);
    }
  }
}
