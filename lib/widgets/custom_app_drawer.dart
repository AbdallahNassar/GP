import 'package:ScaniT/providers/authentication_provider.dart';
import 'package:ScaniT/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drawer_item_model.dart';
import '../screens/top_tabs_screen.dart';
import '../screens/about_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/options_screen.dart';
import './drawer_item.dart';

class CustomAppDrawer extends StatelessWidget {
  // ========================== class parameters ==========================

  final drawerItemList = [
    AppDrawerItemModel(
        title: 'Home',
        icon: Icon(Icons.home),
        calledRouteName: HomeScreen.routeName),
    AppDrawerItemModel(
        title: 'Options',
        icon: Icon(Icons.settings),
        calledRouteName: OptionsScreen.routeName),
    AppDrawerItemModel(
        title: 'About',
        icon: Icon(Icons.supervised_user_circle),
        calledRouteName: AboutScreen.routeName),
    AppDrawerItemModel(
        title: 'Log Out',
        icon: Icon(Icons.exit_to_app),
        calledRouteName: WelcomeScreen.routeName),
  ];
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authentication>(context, listen: false);
    final userName = authProvider.userName[0].toUpperCase() +
            authProvider.userName.substring(1) ??
        'there';

    // print(userName[0].toUpperCase() + userName.substring(1));
    // to register what's the current screeen I was viewing before I pressed on the app drawer
    // so that If I press on the same screen that I'm already in .. I simply pop the app drawer
    final callerRoute = ModalRoute.of(context).settings.name.toString();
    // the application 'drawer'
    return Drawer(
        // a 'column' of items ontop of each other .. the ordering matters.
        child: Column(children: <Widget>[
      // 'appbar' at the top of the 'drawer'
      AppBar(
        backgroundColor: Color(0xFFF5F5F7),
        title: Text(
          'Hello $userName!',
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontFamily: 'Lobster'),
        ),
        // to view the 'image' of the user.
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: authProvider.userName == 'there'
                ? AssetImage(authProvider.userPicURI)
                : NetworkImage(authProvider.userPicURI),
          ),
        ),
        // to remove the 'drawer' from the 'drawer' :'''''D
        automaticallyImplyLeading: false,
      ),
      // ================= Drawer Items =================
      // 'listView' must be wrapped in an 'expanded' if it's put in column .. to prevent errors.
      Expanded(
        child: ListView.builder(
            itemCount: drawerItemList.length,
            itemBuilder: (_, index) =>
                DrawerItem(drawerItemList[index], callerRoute)),
      )
    ]));
  }
}
