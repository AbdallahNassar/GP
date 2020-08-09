import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  // ========================== class parameters ==========================
  final Map<String, String> authData;
  final FocusNode passwordFocusNode;
  final FocusNode userNameFocusNode;
  final String hintText;
  // ========================== class constructor ==========================
  const FormTextField({
    @required this.authData,
    @required this.passwordFocusNode,
    @required this.userNameFocusNode,
    @required this.hintText,
  });

  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // to get the current screen name
    final callerRoute = ModalRoute.of(context).settings.name.toString();
    // get the device dimensions
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
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
        enableInteractiveSelection: true,
        decoration: InputDecoration(
            icon: Icon(
              Icons.people,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            border: InputBorder.none),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        // who will I receive from
        focusNode: hintText.contains('Email') ? null : userNameFocusNode,
        validator: (value) {
          value = value.trim();
          value = value.replaceAll(' ', '');
          if (value.isEmpty) {
            return hintText.contains('Email')
                ? 'Email can\'t be empty.'
                : 'Username can\'t be empty.';
            // don't do there checks on 'username'
          } else if (hintText.contains('Username'))
            return null;
          else if (RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value) ==
              false) {
            return 'Invalid Email Address';
          } else if (value.substring(value.length - 3, value.length) != 'com' &&
              value.substring(value.length - 3, value.length) != 'org' &&
              value.substring(value.length - 3, value.length) != 'net') {
            return 'Invalid Email Address';
          }
          // everything is good .. so return NULL .. that's how the validator works.
          else
            return null;
        },
        // save the data in the template I created at the beginning of this widget;
        onSaved: (value) {
          hintText.contains('Email')
              ? authData['email'] = value.trim()
              : authData['userName'] = value.trim();
        },
        // this allows me to go to the specified 'foucsNode' when I submit this text field.
        onFieldSubmitted: (_) {
          // to make the focus nodes work appropriately
          if (callerRoute != '/login') {
            hintText.contains('Email')
                ? FocusScope.of(context).requestFocus(userNameFocusNode)
                : FocusScope.of(context).requestFocus(passwordFocusNode);
          } else {
            hintText.contains('Email')
                ? FocusScope.of(context).requestFocus(passwordFocusNode)
                : FocusScope.of(context).requestFocus(userNameFocusNode);
          }
        },
      ),
    );
  }
}
