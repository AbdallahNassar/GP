import 'package:flutter/material.dart';

class AppDrawerItemModel {
  // -============================= Class parameters =============================-
  final String title;
  final Icon icon;
  // the one that will be called
  final String calledRouteName;

  // -============================= Class constructor =============================-
  const AppDrawerItemModel({this.icon, this.calledRouteName, this.title});

  // ======================================================================

}
