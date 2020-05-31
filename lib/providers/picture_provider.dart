// to get the '@REQUIRED' decorator.
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// the only reason 'Image' is a provider and not just a 'model' or a 'bluePrint' is that
// I want any 'listeners' for a 'Image' to be notified when the 'Image' changes ..
// A.k.A when it's favourited for example.
class Picture with ChangeNotifier {
  // ==================================== class parameters ====================================
  final String id;
  final String title;
  final String extractedText;
  final String imageURI;
  // to use for filtering
  bool isFavourite;
  // ==================================== class constrictor ====================================
  Picture(
      {@required this.id,
      @required this.title,
      @required this.extractedText,
      @required this.imageURI,
      this.isFavourite = false});

  // ==================================== class methods ====================================
  // 'async' to handle the HTTPRequest and not freeze the entire app while i'm trying to connect
  // to the dataBase .. and 'await' is to hault exectution till I hear back from the server.
  // here I'm optimistically updating the 'isFavourite status' by updating it locally then trying
  // to update it on the dataBase .. and if Database update fails I roll-back the status.
  Future<void> mToggleFavourite({String userID, String authToken}) async {
    isFavourite = !isFavourite;
    notifyListeners();
    // send an http request to the server to upadate the 'favourite' status of the product.
    // setting up the url
    final String collectionName = 'favourites';
    final String dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/$userID/$id.json?auth=$authToken'; // setting up the changedData that I want to send .. I only send what I wish to change.
    // setting up the changedData that I want to send .. I only send what I wish to replace old val with.
    // 'json.encode' is provided by importing 'dart:convert'
    final jsonProduct = json.encode(isFavourite);

    try {
      // I'm manually checking for any errors as the 'http' package only throws an error for the
      // 'post' and 'get' ONLY .. for the rest it DOES NOT throw any thing.
      // use 'put' to override the existing value.
      final response = await http.put(dataBaseUrl, body: jsonProduct);

      if (response.statusCode >= 400) {
        print(response.body);
        print(userID);

        // there's an error .. roll back the changes.
        isFavourite = !isFavourite;
        // to notify all the 'listeners' that something has changed and that they should rebuild.
        notifyListeners();
      }
      // T'll leave this here to handle any 'network' error or smthing.
    } catch (error) {
      // there's an error .. roll back the changes.
      isFavourite = !isFavourite;
      // to notify all the 'listeners' that something has changed and that they should rebuild.
      notifyListeners();
    }
  }
}
