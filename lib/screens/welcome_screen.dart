import '../screens/signup_screen.dart';

import '../screens/login_screen.dart';

import '../helpers/constants.dart';
import '../widgets/round_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/welcome';

  // ========================== class Methods ==========================
  void _mSwitchScreen(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // dimentions of the device
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                  Text(
                    'WELCOME TO SCANIT',
                    style: Theme.of(context).textTheme.headline6,
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
                  RoundFlatButton(
                    text: 'LOGIN',
                    function: _mSwitchScreen,
                    deviceSize: deviceSize,
                    textColor: Colors.white,
                    backgnColor: kPrimaryColor,
                  ),
                  RoundFlatButton(
                    text: 'SIGN UP',
                    function: _mSwitchScreen,
                    deviceSize: deviceSize,
                    textColor: Colors.black,
                    backgnColor: kPrimaryLightColot,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
