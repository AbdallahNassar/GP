import 'package:ScaniT/widgets/api_sign.dart';
import 'package:ScaniT/widgets/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/login_form.dart';
import '../screens/signup_screen.dart';

// stateless to avoid any unnecessart rebuilds
class LoginScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/login';
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    // get the device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: deviceSize.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // top left image
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/main_top.png',
                  width: deviceSize.width * 0.35,
                ),
              ),
              // bottm right image
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/login_bottom.png',
                  width: deviceSize.width * 0.3,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'LOGIN',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    // sitting giril SVG image
                    SvgPicture.asset(
                      'assets/icons/login.svg',
                      height: deviceSize.height * 0.3,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.035,
                    ),
                    // theis where the authentication logic is handled
                    LoginScreenForm(),
                    // =====================================
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an Account?',
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
                              .pushReplacementNamed(SignUpScreen.routeName),
                          child: Text('Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.02,
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
