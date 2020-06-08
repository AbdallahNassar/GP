import 'package:flutter/material.dart';

class FormPasswordField extends StatefulWidget {
  // ========================== class parameters ==========================
  final Map<String, String> authData;
  final String hint;
  final passwordController;
  final passwordFocusNode;
  final confirmPasswordFocusNode;
  // ========================== class constructor ==========================
  const FormPasswordField({
    this.authData,
    this.hint,
    this.confirmPasswordFocusNode,
    this.passwordController,
    this.passwordFocusNode,
  });
  // ======================================================================

  @override
  _FormPasswordFieldState createState() => _FormPasswordFieldState();
}

class _FormPasswordFieldState extends State<FormPasswordField> {
  // ========================== class parameters ==========================
  var _hidePassword = true;
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // to get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
      width: deviceSize.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColorLight),
      child: TextFormField(
        style: Theme.of(context)
            .textTheme
            .headline1
            .copyWith(fontSize: 17, letterSpacing: 0.5),
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          hintText: widget.hint,
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
        textInputAction: (widget.hint == 'Password')
            ? TextInputAction.next
            : TextInputAction.done,
        controller:
            (widget.hint == 'Password') ? widget.passwordController : null,
        focusNode: (widget.hint == 'Password')
            ? widget.passwordFocusNode
            : widget.confirmPasswordFocusNode,
        validator: (value) {
          if (widget.hint == 'Password') {
            if (value.isEmpty || value.length < 5) {
              return 'Password is too short!';
            }
          } else {
            if (value != widget.passwordController.text) {
              return 'Passwords do not match!';
            }
          }
          // everything is good .. so return NULL .. that's how the validator works.
          return null;
        },
        onSaved: (value) {
          widget.authData['password'] = value.trim();
        },
        onFieldSubmitted: widget.hint != 'Password'
            ? null
            : (_) => FocusScope.of(context)
                .requestFocus(widget.confirmPasswordFocusNode),
      ),
    );
  }
}
