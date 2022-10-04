class FuelException {
  String message;
  FuelException(
    this.message,
  );
}

class AddressException extends FuelException {
  AddressException(
    String message,
  ) : super(message);
}
