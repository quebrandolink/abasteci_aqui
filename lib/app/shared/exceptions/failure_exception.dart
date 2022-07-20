import 'package:flutter/cupertino.dart';

abstract class Failure {
  final String errorMessage;

  Failure(
      {StackTrace? stackTrace,
      String? label,
      dynamic exception,
      this.errorMessage = ""}) {
    if (stackTrace != null) {
      debugPrintStack(label: label, stackTrace: stackTrace);
    }

    // todo create error report
  }
}

class UnknownError extends Failure {
  // ignore: annotate_overrides, overridden_fields
  final String errorMessage;
  final dynamic exception;
  final StackTrace? stackTrace;
  final String? label;

  UnknownError({
    this.errorMessage = "Unknown Error",
    this.exception,
    this.stackTrace,
    this.label,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
        );
}
