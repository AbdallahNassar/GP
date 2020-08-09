import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/form_button.dart';
import '../widgets/form_password_field.dart';
import '../widgets/form_text_field.dart';
import '../models/custom_http_exception.dart';
import '../providers/authentication_provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // ========================== class parameters ==========================
  // 'globalKey' to control the 'form' with.
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Template with initial empty data .. and the user enterd data will be in here.
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'userName': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  // MUST be disposed of after the form terminates
  final _passwordFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  // MUST be disposed of after the form terminates
  final _confirmPasswordFocusNode = FocusNode();
  // ========================== class methods ==========================
  // dispose of the 'focusNode' at the end.
  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // show a dialog if there's an error in the authentication process.
  void _showErroDialog({String errorMessage = 'ERROR'}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(errorMessage ??
                  'Could not authenticate you. Please try again later.'),
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
      await Provider.of<Authentication>(context, listen: false).mSignUp(
          _authData['email'], _authData['password'], _authData['userName']);

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
      _showErroDialog(errorMessage: errorMessage);
    } on PlatformException catch (error) {
      print('should be here');
      _showErroDialog(errorMessage: error.message);
    } catch (error) {
      const String errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErroDialog(errorMessage: errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormTextField(
            authData: _authData,
            passwordFocusNode: _passwordFocusNode,
            userNameFocusNode: _userNameFocusNode,
            hintText: 'Your Email',
          ),
          FormTextField(
            authData: _authData,
            passwordFocusNode: _passwordFocusNode,
            userNameFocusNode: _userNameFocusNode,
            hintText: 'Your Username',
          ),
          FormPasswordField(
            authData: _authData,
            hint: 'Password',
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            confirmPasswordFocusNode: _confirmPasswordFocusNode,
          ),
          FormPasswordField(
            authData: _authData,
            hint: 'Confirm Password',
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            confirmPasswordFocusNode: _confirmPasswordFocusNode,
          ),
          FormButton(
            text: 'SIGNUP',
            isLoading: _isLoading,
            submitMethod: _submit,
          ),
          // to add a sized box when the 'sign up' button is removed.
          if (_isLoading == true)
            SizedBox(
              height: 20,
            ),
        ],
      ),
    );
  }
}
