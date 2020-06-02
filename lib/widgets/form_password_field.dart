import 'package:flutter/material.dart';

class FormPasswordField extends StatefulWidget {
  // ========================== class parameters ==========================
  final Map<String, String> _authData;
  // ========================== class constructor ==========================
  const FormPasswordField({
    Key key,
    @required Map<String, String> authData,
  })  : _authData = authData,
        super(key: key);
  // ======================================================================

  @override
  _FormPasswordFieldState createState() => _FormPasswordFieldState();
}

class _FormPasswordFieldState extends State<FormPasswordField> {
  // ========================== class parameters ==========================
  var _hidePassword = true;
  final _passwordController = TextEditingController();
  // MUST be disposed of after the form terminates
  final _passwordFocusNode = FocusNode();
  // ========================== class methods ==========================
  // dispose of the 'focusNode' at the end.
  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // to get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
          widget._authData['password'] = value.trim();
        },
      ),
    );
  }
}
