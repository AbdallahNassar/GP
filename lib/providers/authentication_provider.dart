// this file will manage all our users' logic [Log in - Log out - SignUP]
import 'dart:convert';
// to use the timers
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/custom_http_exception.dart';

// this is a proivder as I want any elements in the UI that depend on our logic here
// change when the data in here change .. 'user is logged in' for example
class Authentication with ChangeNotifier {
  // ========================== class parameters ==========================
  // authentication token
  String _authToken;
  String _userID;
  // to kick the user out once the token expires .. but I will NOT be using it here..
  // but I'll keep it as a future reference for me.
  DateTime _tokenExpiryDate;
  Timer _authTimer;

  String get authToken {
    // if we have an expiry date and it hasn't passed yet
    if (_authToken != null &&
        _tokenExpiryDate != null &&
        _tokenExpiryDate.isAfter(DateTime.now())) {
      return _authToken;
    } else
      return null;
  }

  String get userID {
    // if we have an expiry date and it hasn't passed yet
    return _userID;
  }

  bool get isUserAuth {
    if (authToken != null)
      return true;
    else
      return false;
  }

  // ========================== class methods ==========================
  void _authenticateUser({token, userid, tokenExpiry}) {
    _authToken = token;
    _userID = userid;
    _tokenExpiryDate = tokenExpiry;
    notifyListeners();
    _autoLogOut();
  }

  // 'async' to not freeze the app while i'm waiting for the dataBase response.
  // 'Future<void> because async
  Future<void> mAuthenticate(
      String email, String password, String identifier) async {
    // the default 'URL' is  https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    // but you replace the '[API_KEY]' with your own key .. which you can get from the firebase 'setting'
    // next to the project name then 'project setting'.
    final authenticationKey = 'AIzaSyBM8prCTzoyPGoy9DhPaWEO0lhTSxEzAi0';
    final authenticationURL =
        'https://identitytoolkit.googleapis.com/v1/accounts:$identifier?key=$authenticationKey';

    try {
      // create the request body
      final jsonRequest = json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true});
      // send the request and receive the response in 'JSON' format
      final jsonResponse =
          await http.post(authenticationURL, body: jsonRequest);

      // extract the data from the 'Json' object into a Map
      final response = json.decode(jsonResponse.body);
      // check whether or not there's an error in the response.
      if (response['error'] != null) {
        // I'm throwing my exception with this specific message because I have an idea of the structure of the
        // json response because first I tried to read it and understand it before I decided what to use from it.
        throw CustomHTTPException(message: response['error']['message']);
      }
      // no error .. so every thing is okay .. setUp the token and authenticate the user.
      else {
        _authenticateUser(
            token: response['idToken'],
            // tokenExpiry: DateTime.now().add(Duration(days: 365)),
            tokenExpiry: DateTime.now()
                .add(Duration(seconds: int.parse(response['expiresIn']))),
            userid: response['localId']);

        // now I save the token on the device such that when the user exits the app and come back he'll still be
        // logged in and can directly use the app .. this will be done with 'sharedPrefrences' package and the
        // function containing it should be async.
        // the following line will give me access to the 'sharedPrefernceces' Object so to say
        final sharedPrefs = await SharedPreferences.getInstance();
        // this will be used to write data TO and FROM the device storage.
        final jsonUserData = json.encode({
          '_authToken': _authToken,
          '_userID': _userID,
          // stored as 'Iso8601String' to parse it later as 'dateTime'
          '_tokenExpiryDate': _tokenExpiryDate.toIso8601String()
        });
        sharedPrefs.setString('jsonUserData', jsonUserData);
      }
    } catch (e) {
      // re-throw my error to catch it and handle it somehwere else and show something to the user.
      throw e;
    }
  }

  Future<void> mSignUp(String email, String password) async {
    // I need to return the future that actually does the work so that the spinnder works correctly,
    // so I return the 'future' which I get as the return value of the method 'authenticate' ..
    // otherwise I automatically return the 'future' of the 'signUp' method.
    return mAuthenticate(email, password, 'signUp');
  }

  Future<void> mLogin(String email, String password) async {
    return mAuthenticate(email, password, 'signInWithPassword');
  }

  Future<bool> mTryAutoLogin() async {
    // access the 'shared Pref' package and instanciate an object
    final sharedPrefs = await SharedPreferences.getInstance();
    // check to see if there's any stored data
    if (!sharedPrefs.containsKey('jsonUserData')) {
      return false;
    }
    // get that stored data and decode it
    final extractedUserData = json.decode(sharedPrefs.getString('jsonUserData'))
        as Map<String, dynamic>;
    // check to see if the token has expired or not.
    final expiryDate = DateTime.parse(extractedUserData['_tokenExpiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _authenticateUser(
        token: extractedUserData['_authToken'],
        tokenExpiry: expiryDate,
        userid: extractedUserData['_userID']);
    return true;
  }

  Future<void> mLogOut() async {
    _authToken = null;
    _userID = null;
    _tokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // remove any stored tokens and data from the device to complete the log-out
    final sharedPrefs = await SharedPreferences.getInstance();
    // remove certain data
    // sharedPrefs.remove('jsonUserData');
    // remove everything
    sharedPrefs.clear();
  }

  //  to automatically kick out the user when the token expires.
  void _autoLogOut() {
    // cancel any pre-existing timer and create a new one at the beginning.
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final sessionDuration =
        _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    // available through the 'dart:aysnc' import
    // this will allow my code (my app) to run while in the background (on a diff. thread)
    // having a timer running.. so the following line will
    // wait for a # of seconds (sessionDuration) then execute the funtion given as a pointer.
    _authTimer = Timer(Duration(seconds: sessionDuration), mLogOut);
  }

  // ======================================================================
}
