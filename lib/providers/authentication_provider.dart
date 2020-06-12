// this file will manage all our users' logic [Log in - Log out - SignUP]
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/custom_http_exception.dart';

// this is a proivder as I want any elements in the UI that depend on our logic here
// change when the data in here change .. 'user is logged in' for example
class Authentication with ChangeNotifier {
  // ========================== class parameters ==========================
  var _userName;
  var _userPicURI;
  // authentication token
  var _authToken;
  var _userID;

  // to store the server side reply
  var _serverResponse;

  // instance of 'GoogleSignIn' class to use in 'GooglSignIn' section of this
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // instance of 'facebooksignin' class to use in 'FacebooLogin' section of this
  final FacebookLogin _facebookLogin = FacebookLogin();
  // this handles the communtication betweeen firebase and Google
  final FirebaseAuth _mAuth = FirebaseAuth.instance;

  String get authToken {
    // if we have an expiry date and it hasn't passed yet
    return _authToken;
  }

  String get userID {
    // if we have an expiry date and it hasn't passed yet
    return _userID;
  }

  String get userName {
    return _userName;
  }

  String get userPicURI {
    return _userPicURI;
  }

  bool get isUserAuth {
    if (authToken != null)
      return true;
    else
      return false;
  }

  // ========================== class methods ==========================
  void _authenticateUser({token, userId, userPic, userName}) {
    _authToken = token;
    _userID = userId;
    _userName = userName ?? _userName;
    _userPicURI = userPic ?? 'assets/images/avatar.png';
    notifyListeners();
  }

  // 'async' to not freeze the app while i'm waiting for the dataBase response.
  // 'Future<void> because async
  Future<void> mAuthenticate(
      {String email,
      String password,
      String identifier,
      String userName}) async {
    try {
      // check the sign in mode
      switch (identifier) {
        case 'signUp':
          await _mNativeSingIn(
              identifier: identifier, email: email, password: password);
          await _mAddUserName(userName: userName);
          break;
        case 'signInWithPassword':
          return _mNativeSingIn(
              identifier: identifier, email: email, password: password);
          await _mFetchUserName();
          break;
        case 'singInWithGoogle':
          await _mGoogleSignIn(identifier: identifier);
          break;
        case 'singInWithFacebook':
          await _mFacebookSignIn(identifier: identifier);
          break;
        default:
          throw PlatformException(
              code: 'AUTHENTICATION_ERROR',
              message: 'Wrong Authentication Identifier.');
      }
      await _mFetchUserName();
      // no error .. so every thing is okay .. setUp the token and authenticate the user.
      _authenticateUser(
        token: _serverResponse['idToken'],
        userId: _serverResponse['localId'],
        userName: _serverResponse['name'],
        userPic: _serverResponse['pictureURL'],
      );
      // now I save the token on the device such that when the user exits the app and come back he'll still be
      // logged in and can directly use the app .. this will be done with 'sharedPrefrences' package and the
      // function containing it should be async.
      // the following line will give me access to the 'sharedPrefernceces' Object so to say
      final sharedPrefs = await SharedPreferences.getInstance();
      // this will be used to write data TO and FROM the device storage.
      final jsonUserData = json.encode({
        '_authToken': _authToken,
        '_userID': _userID,
        '_userPicURI': _userPicURI,
        '_userName': _userName,
        // stored as 'Iso8601String' to parse it later as 'dateTime'
      });

      sharedPrefs.setString('jsonUserData', jsonUserData);
    } catch (e) {
      // throw PlatformException(code: 'AUTHENTICATION_ERROE',message: e.message);
      // TODO: uncomment to above
      print('Error occured @ authentication_provider.dart, $e');
    }
  }

  Future<void> _mNativeSingIn(
      {String email, String password, String identifier}) async {
    try {
      // the default 'URL' is  https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
      // but you replace the '[API_KEY]' with your own key .. which you can get from the firebase 'setting'
      // next to the project name then 'project setting'.
      final authenticationKey = 'AIzaSyBM8prCTzoyPGoy9DhPaWEO0lhTSxEzAi0';
      final authenticationURL =
          'https://identitytoolkit.googleapis.com/v1/accounts:$identifier?key=$authenticationKey';

      // create the request body
      final jsonRequest = json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true});
      // send the request and receive the response in 'JSON' format
      final jsonResponse =
          await http.post(authenticationURL, body: jsonRequest);

      // extract the data from the 'Json' object into a Map
      _serverResponse = json.decode(jsonResponse.body);
      // check whether or not there's an error in the response.
      if (_serverResponse['error'] != null) {
        // I'm throwing my exception with this specific message because I have an idea of the structure of the
        // json response because first I tried to read it and understand it before I decided what to use from it.
        throw CustomHTTPException(message: _serverResponse['error']['message']);
      }
      await _mFetchUserName();
      // no error .. so every thing is okay .. setUp the token and authenticate the user.
      _authenticateUser(
        token: _serverResponse['idToken'],
        userId: _serverResponse['localId'],
        userName: _serverResponse['name'],
        userPic: _serverResponse['pictureURL'],
      );
      // now I save the token on the device such that when the user exits the app and come back he'll still be
      // logged in and can directly use the app .. this will be done with 'sharedPrefrences' package and the
      // function containing it should be async.
      // the following line will give me access to the 'sharedPrefernceces' Object so to say
      final sharedPrefs = await SharedPreferences.getInstance();
      // this will be used to write data TO and FROM the device storage.
      final jsonUserData = json.encode({
        '_authToken': _authToken,
        '_userID': _userID,
        '_userPicURI': _userPicURI,
        '_userName': _userName,
        // stored as 'Iso8601String' to parse it later as 'dateTime'
      });

      sharedPrefs.setString('jsonUserData', jsonUserData);
    } catch (e) {
      //TODO : handle this and throw erroe
      print(e);
    }
  }

  Future<void> _mGoogleSignIn({identifier}) async {
    try {
      // this opens the 'google sign in' page handles the Gmail and password
      final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      // check to see if everything went okay
      if (googleAccount != null) {
        // also handles the 'google sign in' popup view
        final googleAuth = await googleAccount.authentication;
        // check to see if anything went wrong
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          // also handles the communtication betweeen firebase and Google
          // this signs the user in and puts his data in firebase
          final authResult = await _mAuth.signInWithCredential(
              GoogleAuthProvider.getCredential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));

          final userToken = await authResult.user.getIdToken();

          _serverResponse = {
            'idToken': userToken.token,
            'localId': authResult.user.uid,
            'pictureURL': authResult.user.photoUrl,
            'name': authResult.additionalUserInfo.profile['given_name'],
          };
        }
      } else {
        // throw PlatformException(
        //    code: 'ERROR_IN_GOOGLE_SIGNIN',
        //    message: 'User calceled the signin',
        // );
        // TODO: uncomment to above
        print('Error occured @ authentication_provider.dart');
      }
    } catch (e) {
      // throw PlatformException(code: 'AUTHENTICATION_ERROE',message: e.message);
      // TODO: uncomment to above
      print('Error occured @ authentication_provider.dart');
    }
  }

  Future<void> _mFacebookSignIn({identifier}) async {
//     switch (result.status) {
//   case FacebookLoginStatus.loggedIn:
//     _sendTokenToServer(result.accessToken.token);
//     _showLoggedInUI();
//     break;
//   case FacebookLoginStatus.cancelledByUser:
//     _showCancelledMessage();
//     break;
//   case FacebookLoginStatus.error:
//     _showErrorOnUI(result.errorMessage);
//     break;
// }
    try {
      // this opens the 'google sign in' page handles the Gmail and password
      final result = await _facebookLogin.logInWithReadPermissions(['email']);
      // check to see if everything went okay
      if (result.accessToken != null) {
        // also handles the communtication betweeen firebase and Google
        // this signs the user in and puts his data in firebase

        final authResult = await _mAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token,
          ),
        );

        final userToken = await authResult.user.getIdToken();

        _serverResponse = {
          'idToken': userToken.token,
          'localId': authResult.user.uid,
          'pictureURL': authResult.user.photoUrl,
          'name': authResult.additionalUserInfo.profile['first_name'],
        };
      } else {
        // throw PlatformException(
        //    code: 'ERROR_IN_GOOGLE_SIGNIN',
        //    message: 'User calceled the signin',
        // );
        // TODO: uncomment to above
        print('Error occured @ authentication_provider.dart 1s');
      }
    } catch (e) {
      // throw PlatformException(code: 'AUTHENTICATION_ERROE',message: e.message);
      // TODO: uncomment to above
      print('Error occured @ authentication_provider.dart ${e.message}');
    }
  }

  Future<void> mSignUp(String email, String password, String username) async {
    // I need to return the future that actually does the work so that the spinnder works correctly,
    // so I return the 'future' which I get as the return value of the method 'authenticate' ..
    // otherwise I automatically return the 'future' of the 'signUp' method.
    await mAuthenticate(
        email: email,
        password: password,
        identifier: 'signUp',
        userName: username);
  }

  Future<void> mLogin(String email, String password) async {
    await mAuthenticate(
        email: email, password: password, identifier: 'signInWithPassword');
  }

  // to login with google/facebook/twitter
  Future<void> mAPILogin({identifier}) async {
    await mAuthenticate(identifier: identifier);
  }

  Future<void> _mAddUserName({String userName}) async {
    final String collectionName = 'usernames';
    final String dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/${_serverResponse['localId']}.json?auth=${_serverResponse['idToken']}';
    // setting up the changedData that I want to send .. I only send what I wish to replace old val with.
    // 'json.encode' is provided by importing 'dart:convert'
    final jsonUserName = json.encode(userName);

    try {
      final response = await http.put(dataBaseUrl, body: jsonUserName);

      if (response.statusCode >= 400) {
        print('Error in adding username to databse.');
      }
      // T'll leave this here to handle any 'network' error or smthing.
    } catch (error) {
      // there's an error .. roll back the changes.
      print('Error in adding username to databse.');
    }
  }

  Future<void> _mFetchUserName() async {
    final String collectionName = 'usernames';
    final dataBaseUrl =
        'https://gp-scanit.firebaseio.com/$collectionName/${_serverResponse['localId']}.json?auth=${_serverResponse['idToken']}';
    try {
      // get the data in the dataBaseUrl
      final response = await http.get(dataBaseUrl);
      // convert them FROM json INTO Map<String,dynamic> OR Map<String,dynamic>
      final respUserName = json.decode(response.body);
      // to not throw an error when the list is empty
      if (respUserName == null) {
        _userName = 'there';
        return;
      }
      _userName = respUserName;
    } catch (e) {
      throw e;
    }
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

    _authenticateUser(
      token: extractedUserData['_authToken'],
      userId: extractedUserData['_userID'],
      userName: extractedUserData['_userName'],
      userPic: extractedUserData['_userPicURI'],
    );

    return true;
  }

  Future<void> mLogOut() async {
    _authToken = null;
    _userID = null;
    _userName = null;
    _userPicURI = null;
    _serverResponse = null;

    try {
      await _googleSignIn.signOut();
      await _mAuth.signOut();
      await _facebookLogin.logOut();
    } catch (e) {
      print('Error @ logging out, $e.messge');
    }

    notifyListeners();
    try {
      // remove any stored tokens and data from the device to complete the log-out
      final sharedPrefs = await SharedPreferences.getInstance();
      // remove certain data
      // sharedPrefs.remove('jsonUserData');
      // remove everything
      sharedPrefs.clear();
    } catch (e) {
      // throw PlatformException(
      //   code: 'SIGN_OUT_ERROR',
      //   message: 'Error Clearing the SharedPrefrences',
      // );
      //TODO: remove comments of above
      print('Error Clearing the SharedPrefrences');
    }
  }

  // ======================================================================
}
