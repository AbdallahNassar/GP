import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  // ========================== class parameters ==========================
  final Map<String, String> _authData;
  // ========================== class constructor ==========================
  const FormTextField({
    Key key,
    @required Map<String, String> authData,
  })  : _authData = authData,
        super(key: key);
  // ======================================================================

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  // ========================== class parameters ==========================
  final FocusNode _passwordFocusNode = FocusNode();

  // ========================== class methods ==========================
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
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
          widget._authData['email'] = value.trim();
        },
        // this allows me to go to the specified 'foucsNode' when I submit this text field.
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(_passwordFocusNode),
      ),
    );
  }
}
