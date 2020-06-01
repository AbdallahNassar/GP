import '../screens/login_screen.dart';

import '../helpers/constants.dart';
import '../widgets/round_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/sign-up';
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
                  width: deviceSize.width * 0.1,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    Text(
                      'SIGNUP',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/signup.svg',
                      height: deviceSize.height * 0.15,
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
                    InputField(
                      deviceSize: deviceSize,
                      hintText: 'Confirm Password',
                      icon: Icons.lock,
                      inputType: TextInputType.url,
                      hideText: true,
                      suffixIcon: Icons.remove_red_eye,
                    ),
                    RoundFlatButton(
                      text: 'SIGNUP',
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
                              .pushNamed(LoginScreen.routeName),
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 7.0),
                      width: deviceSize.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.blueGrey,
                              height: 5,
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.blueGrey,
                              height: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: kPrimaryLightColot, width: 2),
                              shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            'assets/icons/google-plus.svg',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: kPrimaryLightColot, width: 2),
                              shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            'assets/icons/facebook.svg',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: kPrimaryLightColot, width: 2),
                              shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            'assets/icons/twitter.svg',
                            height: 20,
                            width: 20,
                          ),
                        )
                      ],
                    )
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
