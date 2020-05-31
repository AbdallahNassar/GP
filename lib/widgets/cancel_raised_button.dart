import 'package:flutter/material.dart';

class CancelRaisedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 3,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).errorColor.withAlpha(170),
        child: Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // this defines what happen when I press the 'Delete' Icon.
        onPressed: () {
          // show the confirmation Dialogue.
          return showDialog(
              context: context,
              // the shown dialog will be an 'alert Dialog'
              builder: (builderContext) => AlertDialog(
                    // title of the 'alerDialog'
                    title: Text(
                      'Discard Changes?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // body of the 'alertDialog'
                    content: Text(
                      'Do you want to discard any changes you have made?',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        // Returns a [Future] that resolves to the value (if any) that was passed
                        // to [Navigator.pop] when the dialog was closed.
                        onPressed: () =>
                            Navigator.of(builderContext).pop(false),
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        // Returns a [Future] that resolves to the value (if any) that was passed
                        // to [Navigator.pop] when the dialog was closed.
                        onPressed: () => Navigator.of(builderContext).pop(true),
                      )
                    ],
                    // the 'then' fuction will be executed AFTER I choose from the 'shown Dialogue'
                    // hence the name .. Future.
                  )).then((answer) {
            // If the user confirms the deletion.
            if (answer != null && answer == true) Navigator.of(context).pop();
          });
        });
  }
}
