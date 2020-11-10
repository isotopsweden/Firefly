enum InternalError { networkError, queryError, noDocumentsExistError }

final String errorHeading = '🔥 Firefly Error: ';

buildInternalError(InternalError internalError) {
  print(errorHeading + " " + internalError.toString());
}
