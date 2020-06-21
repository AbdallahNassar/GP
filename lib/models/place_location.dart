import 'package:flutter/foundation.dart';

// this class is basically a 'struct' to be used in 'Place' class
class PlaceLocation {
  // ========================== class parameters ==========================
  final double latitude;
  final double longitude;
  final String address;
  // ========================== class constructor ==========================
  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
  // ======================================================================
}
