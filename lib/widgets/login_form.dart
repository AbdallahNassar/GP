import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../widgets/form_password_field.dart';
import '../widgets/form_text_field.dart';
import '../screens/top_tabs_screen.dart';
import '../models/custom_http_exception.dart';

class LoginScreenForm extends StatefulWidget {
  @override
  _LoginScreenFormState createState() => _LoginScreenFormState();
}

class _LoginScreenFormState extends State<LoginScreenForm> {
  // ========================== class parameters ==========================
  // 'globalKey' to control the 'form' with.
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Template with initial empty data .. and the user enterd data will be in here.
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  // ========================== class methods ==========================
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
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // to get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // special looking form text field
          FormTextField(authData: _authData),
          FormPasswordField(authData: _authData),
          if (_isLoading)
            Column(
              children: <Widget>[
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                SizedBox(
                    height: deviceSize.height * 0.03,
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    )),
              ],
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14.0),
              width: deviceSize.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
    );
  }
}
