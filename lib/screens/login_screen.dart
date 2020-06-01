import '../screens/signup_screen.dart';

import '../helpers/constants.dart';
import '../widgets/round_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/login';
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    // get the device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                  'assets/images/main_top.png',
                  width: deviceSize.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/login_bottom.png',
                  width: deviceSize.width * 0.3,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/login.svg',
                    height: deviceSize.height * 0.35,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.035,
                  ),
                  InputField(
                    deviceSize: deviceSize,
                    hintText: 'Your Email',
                    icon: Icons.people,
                    inputType: TextInputType.emailAddress,
                    hideText: false,
                    suffixIcon: null,
                  ),
                  InputField(
                    deviceSize: deviceSize,
                    hintText: 'Password',
                    icon: Icons.lock,
                    inputType: TextInputType.url,
                    hideText: true,
                    suffixIcon: Icons.remove_red_eye,
                  ),
                  RoundFlatButton(
                    text: 'LOGIN',
                    function: () {},
                    deviceSize: deviceSize,
                    textColor: Colors.white,
                    backgnColor: kPrimaryColor,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.01,
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
                            .pushNamed(SignUpScreen.routeName),
                        child: Text('Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  // ========================== class parameters ==========================
  final String hintText;
  final IconData icon, suffixIcon;
  final TextInputType inputType;
  final bool hideText;
  final deviceSize;

  // ========================== class constructor ==========================
  const InputField(
      {this.hintText,
      this.icon,
      this.inputType,
      this.hideText,
      this.deviceSize,
      this.suffixIcon});
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      width: deviceSize.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: kPrimaryLightColot),
      child: TextField(
        cursorColor: kPrimaryColor,
        keyboardType: inputType,
        obscureText: hideText,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            suffixIcon: Icon(
              suffixIcon,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            border: InputBorder.none),
      ),
    );
  }
}
