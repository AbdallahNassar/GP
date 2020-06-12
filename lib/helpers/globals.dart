import 'package:flutter/material.dart';

//  a GlobalKey to associate it with the home page [toptabs] Scaffold widget,
// and use the context from thas widget's key when creating the dialog
// to corrctoly handle pictrue deletion and restoration.
MyGlobals myGlobals = new MyGlobals();

class MyGlobals {
  GlobalKey<ScaffoldState> _homeScaffoldKey;
  MyGlobals() {
    _homeScaffoldKey = GlobalKey();
  }
  GlobalKey get homeScaffoldKey => _homeScaffoldKey;
}
