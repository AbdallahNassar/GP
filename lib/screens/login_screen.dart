import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../screens/top_tabs_screen.dart';
import '../screens/signup_screen.dart';
import '../providers/authentication_provider.dart';
import '../models/custom_http_exception.dart';

class LoginScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static const routeName = '/login';
  // ===================================================================
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ========================== class parameters ==========================
  // 'globalKey' to control the 'form' with.
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Template with initial empty data .. and the user enterd data will be in here.
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _hidePassword = true;
  final _passwordController = TextEditingController();
  // MUST be disposed of after the form terminates
  final _passwordFocusNode = FocusNode();
  // MUST be disposed of after the form terminated
  final _confirmPassFocusNode = FocusNode();

  // ========================== class methods ==========================
  // dispose of the 'focusNode' at the end.
  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  void _showErroDialog({String errorMessage = 'ERROR'}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(errorMessage),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ));
  }

  // 'async' as it will call some 'async' methods that will return a 'future'
  Future<void> _submit() async {
    // check if the datat is valid or not.
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // call the sign up method in the 'authentication' provider .. and 'await' to not
      // freeze the app .. and I only want to sign up so 'listen' is false;
      await Provider.of<Authentication>(context, listen: false)
          .mLogin(_authData['email'], _authData['password']);

      Navigator.of(context).pushReplacementNamed(TopTabsScreen.routeName);
      // to check if I get a specific kind of error/exception rather than check for any error/exception.
      // I could also have a normal generic 'catch' after the 'on ... catch'.
    } on CustomHTTPException catch (error) {
      var errorMessage;
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      print('Error  Message @ auth card: $errorMessage');
      _showErroDialog(errorMessage: errorMessage);
    } catch (error) {
      const String errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErroDialog(errorMessage: errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ==================================================================
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
              SingleChildScrollView(
                child: Column(
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 7.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            width: deviceSize.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColorLight),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,

                              enableInteractiveSelection: true,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.people,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  hintText: 'Your Email',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,

                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                // everything is good .. so return NULL .. that's how the validator works.
                                return null;
                              },
                              // save the data in the template I created at the beginning of this widget;
                              onSaved: (value) {
                                _authData['email'] = value.trim();
                              },
                              // this allows me to go to the specified 'foucsNode' when I submit this text field.
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode),
                            ),
                          ),
                          Container(
                            // alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(vertical: 7.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            width: deviceSize.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColorLight),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,

                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              // to show the password as 'Rounded Bold Dots'.
                              obscureText: _hidePassword,
                              textInputAction: TextInputAction.done,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              validator: (value) {
                                if (value.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                                // everything is good .. so return NULL .. that's how the validator works.
                                return null;
                              },
                              onSaved: (value) {
                                _authData['password'] = value.trim();
                              },
                            ),
                          ),
                          if (_isLoading)
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: deviceSize.height * 0.03,
                                ),
                                SizedBox(
                                    height: deviceSize.height * 0.03,
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )),
                              ],
                            )
                          else
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              width: deviceSize.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  onPressed: () => _submit(),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColorLight),
      child: TextField(
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: inputType,
        obscureText: hideText,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: Icon(
              suffixIcon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            border: InputBorder.none),
      ),
    );
  }
}
