// import 'package:ScaniT/providers/picture_provider.dart';
// import 'package:ScaniT/providers/pictures_provider.dart';
// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ScaniT/widgets/home_grid.dart';

class FavouritesScreen extends StatelessWidget {
  // -============================= Class Parameters =============================-
  // 'routeName' to be used in the routing table to help with the screen selection.
  static const routeName = '/favourites';

  @override
  Widget build(BuildContext context) {
    return HomeScreenGrid(
      routeName: routeName,
    );
  }
}
