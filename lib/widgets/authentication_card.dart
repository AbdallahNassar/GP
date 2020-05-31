import '../models/custom_http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';

enum AuthMode { Signup, Login }

class AuthenticationCard extends StatefulWidget {
  @override
  _AuthenticationCardState createState() => _AuthenticationCardState();
}

class _AuthenticationCardState extends State<AuthenticationCard> {
  // ========================== class parameters ==========================

  // 'globalKey' to control the 'form' with.
  final GlobalKey<FormState> _formKey = GlobalKey();
  // the default is the 'login' mode.
  AuthMode _authMode = AuthMode.Login;
  // Template with initial empty data .. and the user enterd data will be in here.
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
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

  // change the 'mode' of the 'auth screen'
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  // TODO: change error handling .. show the error text in red in the form text field.
  // show a dialog if there's an error in the authentication process.
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
      if (_authMode == AuthMode.Login) {
        // call the sign up method in the 'authentication' provider .. and 'await' to not
        // freeze the app .. and I only want to sign up so 'listen' is false;
        await Provider.of<Authentication>(context, listen: false)
            .mLogin(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Authentication>(context, listen: false)
            .mSignUp(_authData['email'], _authData['password']);
      }
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
      print('Error  Message @ auth card: $errorMessage');
      _showErroDialog(errorMessage: errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ======================================================================

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        // decide height based on the mode
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        // a form .. that's one of the reasons why this 'widget' is 'stateful'
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  enableInteractiveSelection: true,
                  decoration: InputDecoration(labelText: 'E-Mail'),
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
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  // to show the password as 'Rounded Bold Dots'.
                  obscureText: true,
                  textInputAction: (_authMode == AuthMode.Login)
                      ? TextInputAction.done
                      : TextInputAction.next,
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
                  onFieldSubmitted: (_authMode == AuthMode.Login)
                      ? null
                      : (_) => FocusScope.of(context)
                          .requestFocus(_confirmPassFocusNode),
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    focusNode: _confirmPassFocusNode,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 25,
                ),
                if (_isLoading)
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20, child: CircularProgressIndicator()),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    // this button will call the submit method on every 'textFormField' when pressed.
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  // to shrink the button a little bit .. it'll reduce the surface area of the button.
                  // so I have to press on it exactly.
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
