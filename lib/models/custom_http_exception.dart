class CustomHTTPException {
  // ========================== class parameters ==========================
  final String message;

  // =========================== class constructors ===========================
  const CustomHTTPException({this.message});

  // =========================== class methods ===========================
  // to return my own message when I call this custom exception.
  @override
  String toString() {
    return message;
  }

  // ======================================================================
}
