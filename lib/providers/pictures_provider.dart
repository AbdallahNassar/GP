import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/location_helper.dart';
import '../models/place_location.dart';
import '../models/custom_http_exception.dart';
import './picture_provider.dart';

// 'with' key words is a 'lite inheretence' as your get some of the properties of another class
// but you don't turn your class into an instance of it.
// 'changeNotifier' is to help establish the behind the scenes communication tunnels which
//  the 'provider' package will be using to manage my states .. providers are used to prevent having to
// pass arguments to a 'widget' that will NOT use these arguments but simply forward them to it's child or smth.

class Pictures with ChangeNotifier {
  // ========================== class parameters ==========================
  // not final because I want it to change over time
  // the '_' at the beginning of the object's name is to illaburate that this object's value
  // should not be changed from outside of this class .. a 'private' object as to say.

  //to be used in restoring the deleted picture when the user presses on the 'undo' button.
  var _lastDeletedPictureIndex = -1;
  List<Picture> userPictures = [];

  // 'get' is for any outside class to access my object (PictureList) because it is PRIVATE
  // '[...ListName]' is a 'spreader' to convert my list into it's elements .. so now I will
  // be returning a copy of them I could've alse used the 'toList()' att. is so that I don't return the address
  // of the list but I return the list items.
  List<Picture> get pictureList {
    return [...userPictures];
  }

  // the 'toList()' attribute is to convert result of the 'where' attribute into a list
  // as it returns a tuple or some other thing.
  List<Picture> get favouritepicturesList {
    return userPictures.where((item) => item.isFavourite == true).toList();
  }

  // to be used in database .. to log user in and keep him in .. and for every user to only see his items from DB
  final String authToken;
  final String userID;
  // ========================== class class constructor ==========================
  Pictures({this.userPictures, this.authToken, this.userID});

  // ========================== class methods ==========================
  // this function will send a 'get' request to the 'database' .. retrieve the items and show them.
  // will be 'async' because I'm working with a server and database and i'm not sure when/if it succeedes..
  // so i'll show a loadingSpinner till I either fetch my data or show an error.
  // 'async' to not freeze the application while I'm waiting for this function to finish as all the method
  // body 'the function body' will AUTOMATICALLY be wrapped in a 'future' and also return a 'future'.
  Future<void> mFetchData() async {
    // all the following is specific to 'firebase' only and may be totally different on other DataBAses.
    // 'url' is the databaseHandler or Pointer .. that I will talk to the database's webserver through.
    // '?' marks the beginning of all the optional parameters .. 'auth=' to supply the authentication token
    // 'orderBy=ATTNAME&equalTo=USERID' to filter the items you will be getting .. here I'm filtering by
    // the 'userID' .. so I'll only receive the items that have 'UserID' value as their 'CreatorID'.
    // 'collection' is a kinda of a 'folder' inside my database.
    final String collectionName = 'pictures';
    final dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName.json?auth=$authToken&orderBy="creatorID"&equalTo="$userID"';
    try {
      // get the data in the dataBaseUrl
      final response = await http.get(dataBaseUrl);
      // convert them FROM json INTO Map<String,dynamic> OR Map<String,dynamic>
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // to not throw an error when the list is empty
      if (extractedData == null || extractedData['error'] != null) {
        // this is to handle expired tokens
        if (extractedData['error'] != null)
          print(extractedData['error'] != null);
        userPictures = [];
        return;
      }

      // now after I've fetched my pictures I wanna fetch my 'favourite' status for all the pictures
      final String favouritesCollectionName = 'favourites';
      final String favouritesDataBaseUrl =
          'https://gp-scanit.firebaseio.com/$favouritesCollectionName/$userID.json?auth=$authToken';
      final jsonFavResponse = await http.get(favouritesDataBaseUrl);
      final favResponse = json.decode(jsonFavResponse.body);
      // a List to put all the data In .. THEN put all the data in the pictureList such that each time
      // this runs the 'pictureList' gets re-written with the newest item from database rather than
      // getting the same items over and over on top of each other.
      final List<Picture> _extractredItemList = [];
      // perform the following function on every item in the 'extractedData' Map.
      extractedData.forEach((itemID, itemMap) {
        // extract data from each 'itemMap' and fill a picture with it and add it into the dummy list;
        _extractredItemList.add(Picture(
          id: itemID,
          extractedText: itemMap['extractedText'],
          imageURI: itemMap['imageURI'],
          title: itemMap['title'],
          location: PlaceLocation(
            latitude: itemMap['loc_lat'],
            longitude: itemMap['loc_lng'],
            address: itemMap['address'],
          ),

          // chech whether or not the user has any favourite items or not .. then it checks
          // whether or not we have an entry in the favoutire list for the item with this id
          // and if that's the case the I use it otherwise I just put it as false;
          // '??' checks whether or not the value before it is null
          isFavourite:
              favResponse == null ? false : favResponse[itemID] ?? false,
        ));
      });
      // this line so that when I reload the page it doesn't add all the database items to the ones that
      // already exist in the database .. so to avoid duplication .. I re-set the list each time the widget is loaded.
      userPictures = _extractredItemList.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> mAddPicture({Picture picture, String identifier = 'Add'}) async {
    // the following code will be for 'http' requests .. to 'post' data into a database
    // through it's 'webserver' .. 'webserver' will be the middle man between the database and I.
    // 'collection' is a kinda of a 'folder' inside my database.
    const String collectionName = 'pictures';
    // 'url' is the databaseHandler or Pointer .. that I will talk to the database's webserver through.
    final String dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName.json?auth=$authToken';

    // I convert the location from (lat,long)  into a human readable address after
    // I check if a locatin was provided by the user or not [maybe he declided the
    final locAddress = picture.location == null
        ? null
        : await LocationHelper.getPlaceAddress(
            picture.location.latitude, picture.location.longitude);
    // create a new location with a human readable address
    final updatedLocation = picture.location == null
        ? null
        : PlaceLocation(
            latitude: picture.location.latitude,
            longitude: picture.location.longitude,
            address: locAddress);
    // create a new place
    // this is a built-in library that will convert Item --into--> Json.
    final jsonPicture = json.encode({
      // no ID as i'll be using the ID generated automatically for me by the fireDataBase.
      //'id': DateTime.now().toString(),
      'creatorID': userID,
      'extractedText': picture.extractedText,
      'imageURI': picture.imageURI,
      'title': picture.title,
      'loc_lat': picture.location == null ? null : updatedLocation.latitude,
      'loc_lng': picture.location == null ? null : updatedLocation.longitude,
      'address': picture.location == null ? null : updatedLocation.address,
    });

    // if I want to restore a deleted picture .. I should also restore it's favourite status
    var oldFavStat = false;
    if (identifier != 'Add') {
      oldFavStat = await mWasPicFav(id: picture.id);
      print(oldFavStat);
    }
    // 'http' is a library that I manually included in 'pubspec.yaml'
    // 'post' returns a 'future' after it's DONE executed .. this fucntion needs to return a 'future'
    //  when it's done so that the loading spinner disappears and the 'screen' can 'pop'.
    //  'await' means that this code will be done 'Asyncronouslly' , BUT it does NOT means that the
    //  compilor will wait for the return .. it LOOKS LIKE it stoppes executions and waits for the resp.
    // but,behind the scenes, it actually doesn't .. it will move onto other lines of code till this finishes.

    // try-catch should only be used with SYNCHRONOUS code .. but the 'await' makes my code 'as if it's synchro.'
    // so I can use it here to catch any errors that might occur.
    try {
      // saving the respnse to extract the ID from.
      final response = await http.post(dataBaseUrl, body: jsonPicture);
      final newPicture = Picture(
        // 'name' is a map entry (in reponse body , which is a map) that has a unique random string that
        // 'firebase' generates for every item .. so I'll use that as the picture's ID.
        id: (identifier == 'Add')
            ? json.decode(response.body)['name']
            : picture.id,
        extractedText: picture.extractedText,
        imageURI: picture.imageURI,
        title: picture.title,
        isFavourite: oldFavStat,
        location: picture.location,
      );
      if (identifier == 'Add')
        userPictures.insert(0, newPicture);
      else if (identifier == 'Restore')
        userPictures.insert(_lastDeletedPictureIndex, newPicture);
      // to notify all the listeners of this class (widgets) that a change has happened.
      // so that they can be rebuilt.. and that's why I return a copy of the list and not
      // a reference 'pointer' to it.
      notifyListeners();
    } on Exception catch (e) {
      // re-throw the error to be cought somewhere else.
      throw e;
    }
  }

  Future<void> mUpdatePicture(Picture picture) async {
    // I convert the location from (lat,long)  into a human readable address after
    // I check if a locatin was provided by the user or not [maybe he declided the
    final locAddress = picture.location == null
        ? null
        : await LocationHelper.getPlaceAddress(
            picture.location.latitude, picture.location.longitude);
    // create a new location with a human readable address
    final updatedLocation = picture.location == null
        ? null
        : PlaceLocation(
            latitude: picture.location.latitude,
            longitude: picture.location.longitude,
            address: locAddress);

    final String collectionName = 'pictures';
    final dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/${picture.id}.json?auth=$authToken';
    final jsonpicture = json.encode({
      'extractedText': picture.extractedText,
      'imageURI': picture.imageURI,
      'title': picture.title,
      'loc_lat': picture.location == null ? null : updatedLocation.latitude,
      'loc_lng': picture.location == null ? null : updatedLocation.longitude,
      'address': picture.location == null ? null : updatedLocation.address,
    });
    // I handle the error this way as the database only throws an error with 'post' and 'get'
    final response = await http.patch(dataBaseUrl, body: jsonpicture);
    // the request has failed
    if (response.statusCode >= 400)
      throw CustomHTTPException(message: 'Something went wrong!');

    // the request has succeeded.
    else {
      final int _pictureIndex =
          userPictures.indexWhere((item) => item.id == picture.id);
      userPictures[_pictureIndex] = picture;
      // to notify all the listeners of this class (widgets) that a change has happened.
      // so that they can be rebuilt.. and that's why I return a copy of the list and not
      // a reference 'pointer' to it.
      notifyListeners();
    }
  }

  // applying 'Optemistic Update .. where I Re-add the item to the list if
  // the delete fails By deleting the item from the list first, before I
  // delete it from the dataBase and keeping the deleted item in memory
  Future<void> mDeletePicture({picID}) async {
    _lastDeletedPictureIndex =
        userPictures.indexWhere((item) => item.id == picID);

    var _storedInMemoryPicture = userPictures[_lastDeletedPictureIndex];
    userPictures.removeAt(_lastDeletedPictureIndex);
    notifyListeners();

    // performing the deletion in the database.
    final String collectionName = 'pictures';
    final dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/$picID.json?auth=$authToken';

    // I'll not wrap this in a 'try-catch- as the 'delete' in database does NOT throw errors.
    // instead i'll use the response I get from the database to check whether or not there's an error.
    final response = await http.delete(dataBaseUrl);

    // an error has occured.
    if (response.statusCode >= 400) {
      // re-introduce the picture that I had already deleted.
      userPictures.insert(_lastDeletedPictureIndex, _storedInMemoryPicture);
      notifyListeners();
      // throw my own custom exception to be handled by the calling widget.
      throw CustomHTTPException(message: 'Something went wrong!');
    } else
      // the deletion from the database is successful so I should also delete the item from memory.
      _storedInMemoryPicture = null;
  }

  // if I want to restore a deleted picture .. I should also restore it's favourite status
  Future<bool> mWasPicFav({id}) async {
    // setup the database connection
    const String collectionName = 'favourites';
    final String dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/$userID.json?auth=$authToken';
    // check to see if the user had any favourites and if so then what was the deleted pic's fav status
    final jsonFavResponse = await http.get(dataBaseUrl);
    final favResponse = json.decode(jsonFavResponse.body);
    // do logic based on what you get
    final bool oldFavStat =
        favResponse == null ? false : favResponse[id] ?? false;
    // if (oldFavStat == false){
    //   Provider.of<Picture>(context,listen:false)
    // }
    return oldFavStat;
  }

  // we define this function because we want to move as much of the providing logic
  // from our 'widgets' into the 'provider' itself, for some consmic reason.
  Picture mFindByID(id) {
    try {
      return userPictures.firstWhere((item) => item.id == id) ?? null;
    } catch (e) {
      return null;
    }
  }
}
