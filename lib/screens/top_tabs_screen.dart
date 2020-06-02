import 'package:ScaniT/widgets/custom_app_drawer.dart';
import 'package:flutter/services.dart';
import '../screens/update_image_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/home_page_screen.dart';
import 'package:flutter/material.dart';

class TopTabsScreen extends StatelessWidget {
  static const routeName = '/top-tabs';
  @override
  Widget build(BuildContext context) {
    // to allow any device orientation after it was locked to PORTRAIT in 'Sign' Screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //'DefaultTabController' to create my tabs under the 'appbar'
    // it will AUTOMOATICALLY link the 'tab' you pressed with it's corresponding 'screen'
    // in the 'tabbarview' bellow , everything is done behind the scenes .. you just have to
    // have the right components .. 'DefaultTabController' , 'TabBar' , 'Tab' , 'TabBarView'
    return DefaultTabController(
      // # of tabs
      length: 2,
      // the first chosen item is intitially the 'i th' item .. i is set in the line blow
      initialIndex: 0,
      // 'scaffold' because the 'tabs' screen will return a page or 'screen' in the end
      child: Scaffold(
        drawer: CustomAppDrawer(),
        appBar: AppBar(
          title: Text('ScaniT'),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(UpdatePictureScreen.routeName),
              icon: Icon(
                Icons.add,
                size: 25,
                color: Theme.of(context).textTheme.button.color,
              ),
            )
          ],
          // the 'tabbar' to be shown at the 'bottom' of the appbar
          bottom: TabBar(
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).textTheme.body1.color,
            // labelStyle: Theme.of(context).textTheme.body1,
            // 'tabs' takes a list of 'tab widgets' and each one will be a 'tab'
            tabs: <Widget>[
              // the first 'tab'
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 18,
                ),
                text: 'Home Page',
              ),
              // the second 'tab'
              Tab(
                icon: Icon(
                  Icons.star,
                  size: 18,
                ),
                text: 'Favourites',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // this first element will be shown AUTOMATICALLY if you press the first 'tab' in the 'tabbar' above
            HomePageScreen(),
            // the second element will be shown AUTOMATICALLY if you press the second 'tab' in the 'tabbar' above .. and so on
            FavouritesScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // Open the 'UpdatePicture Screen'.
          onPressed: () =>
              Navigator.of(context).pushNamed(UpdatePictureScreen.routeName),
          child: Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).textTheme.button.color,
          ),
        ),
      ),
    );
  }
}
