import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/welcome';
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // dimentions of the device
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: deviceSize.height,
          width: double.infinity,
          // items will be from top to bottom of the stack
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // top most item
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/main_top.png',
                  width: deviceSize.width * 0.25,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/main_bottom.png',
                  width: deviceSize.width * 0.13,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    RichText(
                      text: TextSpan(
                        // this style will be global unless there's a defined style in the child text
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 22),
                        children: <TextSpan>[
                          TextSpan(text: 'WELCOME TO '),
                          TextSpan(
                              text: 'SCANiT',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 26,
                                  ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    SvgPicture.asset(
                      'assets/icons/chat.svg',
                      height: deviceSize.height * 0.45,
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7.0),
                      width: deviceSize.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7.0),
                      width: deviceSize.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FlatButton(
                          color: Theme.of(context).primaryColorLight,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.routeName),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
