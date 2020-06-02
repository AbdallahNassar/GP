import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  // ========================== class parameters ==========================
  final Map<String, String> authData;
  final FocusNode passwordFocusNode;
  // ========================== class constructor ==========================
  const FormTextField({
    @required this.authData,
    @required this.passwordFocusNode,
  });

  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // get the device dimensions
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
        enableInteractiveSelection: true,
        decoration: InputDecoration(
            icon: Icon(
              Icons.people,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Your Email',
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
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
          authData['email'] = value.trim();
        },
        // this allows me to go to the specified 'foucsNode' when I submit this text field.
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(passwordFocusNode),
      ),
    );
  }
}
