import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './screens/test_screen.dart';
import './screens/about_screen.dart';
import './screens/update_image_screen.dart';
import './screens/picture_details_screen.dart';
import './screens/favourites_screen.dart';
import './screens/top_tabs_screen.dart';
import './screens/options_screen.dart';
import './screens/home_page_screen.dart';
import './screens/authentication_screen.dart';
import './screens/splash_screen.dart';

import './providers/pictures_provider.dart';
import './providers/authentication_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 'changeNotifierProvider' allows us to register a "class" or a " widget " to which you can listen for in child widgets
    // and whenever that 'class' updates .. all the 'listenning childs' will aslo update and rebuild.
    //  providers are used to prevent having to pass arguments to a 'widget' that will NOT use these arguments but simply
    // forward them to it's child or smth.

    // I could only use 'ChangeNotifierProvider' here but the '.value' constructor is BEST suited when you
    // are 'providing' your data with single Lists or grids items .. so that flutter can recycle the 'widget' that's
    // attached to the provider .. and 'ChangeNotifierProvider' cleans up the data in memory to avoid memory Leaks.

    // 'MultiProvider' is provided by the 'provider' package and it allows me to have multiple providers :''D
    // and the 'child' of it will be capable of 'LISTENING' to all of these providers.
    return MultiProvider(
      // this returns a new 'instance' of my provider class so that I can 'provide ' it to all it's listeners
      // which now are 'MaterialApp' and all of it's children.
      providers: [
        // the 'auth provider' must be the FIRST ONE in the list for the 'Proxy provider' to work correctly.
        ChangeNotifierProvider.value(value: Authentication()),
        // 'ProxyProvider' creates a 'provider' which depends on another 'provider'.. defined BEFORE this one.
        ChangeNotifierProxyProvider<Authentication, Pictures>(
            update: (_, authProvider, prevPics) => Pictures(
                userPictures: prevPics == null ? [] : prevPics.pictureList,
                authToken: authProvider.authToken,
                userID: authProvider.userID)),
      ],
      // I'll wrapp the 'materialApp' in a 'consumer' as I want it Only to rebuit when the user enters his
      // credentials .. and I'll put the 'screen' change logic here .. so that I can preform a check on
      // whether or not the 'user' is already logged in and whether or not I should start with the 'auth screen'
      child: Consumer<Authentication>(
        // the 'child' part is to indicate that there's a 'static' part that I wish to NOT re-build.
        builder: (_, authProvider, child) => MaterialApp(
          title: 'Home Page',
          theme: ThemeData(
              primarySwatch: Colors.indigo,
              primaryColor: Colors.indigo,
              accentColor: Colors.deepOrange[300],
              textTheme: const TextTheme(
                  title: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  button: const TextStyle(color: Colors.white),
                  subtitle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  body1: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  )),
              appBarTheme: const AppBarTheme(
                  textTheme: const TextTheme(
                      title: const TextStyle(
                          fontFamily: 'Rochester',
                          fontSize: 21,
                          fontWeight: FontWeight.bold)))),

          // THIS is the 'homePage' of the entire application so to speak.
          // check to see if the user is logged in or not
          home: authProvider.isUserAuth
              ? TopTabsScreen()
              // the user is NOT logged in .. so i'll check for a token and try to
              // automatically log him in.
              : FutureBuilder(
                  // the future i'll be waiting on it's result.
                  future: authProvider.mTryAutoLogin(),
                  builder: (_, dataSnapShot) =>
                      // I'm still waiting on the database response.
                      (dataSnapShot.connectionState == ConnectionState.waiting)
                          ?
                          // this screen will be the waiting screen for the user to see while the 'auto loggin' is being executed
                          // and when the autoLogin is finished .. the 'notifyListeners' will be called and this entire screen
                          // will be rebuilt and the condition 'authProvider.isUserAuth' will be true so I won't render the auth screen.
                          SplashScreen()
                          : AuthenticationScreen(),
                ),

          // home: TestScreen(),

          // a 'route' is a different application 'screen' or 'page' .. this is a map of routes
          // each route has an identifier that's connected to a certain 'widget' or 'screen' or 'page'
          routes: {
            // could aslo have used 'bottomtabsScreen' if I'd wanted to.
            TopTabsScreen.routeName: (context) => TopTabsScreen(),
            HomePageScreen.routeName: (context) => HomePageScreen(),
            OptionsScreen.routeName: (context) => OptionsScreen(),
            FavouritesScreen.routeName: (context) => FavouritesScreen(),
            PictureDetails.routeName: (context) => PictureDetails(),
            UpdatePictureScreen.routeName: (context) => UpdatePictureScreen(),
            AboutScreen.routeName: (context) => AboutScreen(),
          },

          // 'onGenerateRoute' is the default 'route' to take for any 'route' or 'screen' that is
          // not defined in the routing table above
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (_) => TopTabsScreen());
          },

          // 'Unknwon Route' is reached when flutter fails to build a screen with all the above methods
          // e.g. using the table route or using 'onGenerateRoute' .. your '404' page.
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (_) => TopTabsScreen());
          },
        ),
      ),
    );
  }
}
