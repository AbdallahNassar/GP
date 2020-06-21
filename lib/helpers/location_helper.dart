import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyBqeMjIznQAARCTcT_NVhxpABh3InbxjVc';

class LocationHelper {
  // to create an image of the current location on the location preview box
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  // to convert the lat,long into a human readble address
  static Future<String> getPlaceAddress(double lat, double lng) async {
    try {
      // the url of the API that will handle the conversion for me.
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
      // sending the get request with my location data for the conversion
      final response = await http.get(url);
      // get the result and pass it back.
      return json.decode(response.body)['results'][0]['formatted_address'];
    } catch (e) {
      print('error @ loation helper , $e');
      return null;
    }
  }
}
