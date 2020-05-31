import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/authentication_card.dart';

class AuthenticationScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/authentication';
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // 'safeArea' to respect the notch.
      body: Stack(
        children: <Widget>[
          // this will be the last item.
          Container(
            decoration: BoxDecoration(
              // to have the gradient effect
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).accentColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.99),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          // to be scrollable to accomidate to different devices sizes.
          SingleChildScrollView(
            // 'container' to restrict the scrolling.
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 'flexible' to distribute the space between the App Name Banner and the 'auth card'
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 90.0),
                      // 'transfrom' is for 're-sizing' .. 're-scalling' .. 'moving' the containger on the screen.
                      // '..' means that I call a method that 'edits' my item and returns an edited item in it's place.
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).accentColor,
                        boxShadow: [
                          // the shadow around the item .. 'app name banner'
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'ScaniT',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Lobster',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    // to increase the 'authentication card' height in landscape mode;
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthenticationCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
