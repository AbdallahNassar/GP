import 'package:flutter/material.dart';
import '../widgets/home_grid.dart';

class HomePageScreen extends StatelessWidget {
  // -============================= Class Parameters =============================-
  // 'routeName' to be used in the routing table to help with the screen selection.
  static const routeName = '/home-page';

  @override
  // seperation as I use it in multiple locations.
  Widget build(BuildContext context) {
    return HomeGrid(routeName: '/');
  }
}
