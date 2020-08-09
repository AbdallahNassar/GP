import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/api_sign.dart';
import '../widgets/or_divider.dart';
import '../widgets/signup_form.dart';
import '../screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/sign-up';
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // get the device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // to respect the device notches
      body: SafeArea(
        child: Container(
          height: deviceSize.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/signup_top.png',
                  width: deviceSize.width * 0.25,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/login_bottom.png',
                  width: deviceSize.width * 0.25,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/main_bottom.png',
                  width: deviceSize.width * 0.2,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'SIGNUP',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/signup.svg',
                      height: deviceSize.height * 0.2,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: deviceSize.height * 0.52),
                      child: SingleChildScrollView(child: SignUpForm()),
                    ),
                    // SizedBox(
                    //   height: deviceSize.height * 0.02,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already have an Account?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: deviceSize.width * 0.02,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName),
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                        ),
                      ],
                    ),
                    ORDivider(),
                    APISign()
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
