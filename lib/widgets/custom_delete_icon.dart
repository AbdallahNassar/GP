import '../providers/picture_provider.dart';
import '../providers/pictures_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDeleteIcon extends StatelessWidget {
  // ========================== class parameters ==========================
  CustomDeleteIcon({
    Key key,
    @required this.picture,
    @required this.savedScaffold,
    @required this.savedTheme,
  }) : super(key: key);

  final Picture picture;
  final savedScaffold;
  final ThemeData savedTheme;

  final _hasError = [];
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    // final picturesProvider = Provider.of<Pictures>(context, listen: false);

    return IconButton(
        alignment: Alignment.centerLeft,
        icon: Icon(
          Icons.delete,
          color: savedTheme.errorColor,
        ),

        // this defines what happen when I press the 'Delete' Icon.
        // 'async' to enabel 'await' and future-wrapp my entire function.
        onPressed: () async {
          // show the confirmation Dialogue.
          //'await' to wait for the user response befor I move on.
          final answer = await showDialog(
              context: context,
              // the shown dialog will be an 'alert Dialog'
              builder: (_) => AlertDialog(
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    // backgroundColor: savedTheme.textTheme.button.,

                    // title of the 'alerDialog'
                    title: Text(
                      'Are you sure ?',
                      textAlign: TextAlign.center,
                    ),
                    // body of the 'alertDialog'
                    content: Text(
                      'Do you want to remove this item from the List ?',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        // Returns a [Future] that resolves to the value (if any) that was passed
                        // to [Navigator.pop] when the dialog was closed.
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        // Returns a [Future] that resolves to the value (if any) that was passed
                        // to [Navigator.pop] when the dialog was closed.
                        onPressed: () => Navigator.of(context).pop(true),
                      )
                    ],
                    // the 'then' fuction will be executed AFTER I choose from the 'shown Dialogue'
                    // hence the name .. Future.
                  ));
          // If the user confirms the deletion.
          if (answer != null && answer == true) {
            try {
              await Provider.of<Pictures>(context, listen: false)
                  .mDeletePicture(picID: picture.id);
              _hasError.add(false);
            } catch (e) {
              _hasError.add(true);
            } finally {
              // Second: we show a pop-up or 'snackbar' to provide some information to the user.
              // this next line is to hide the previous snackbar
              savedScaffold.hideCurrentSnackBar();
              // 'scaffold' here takes the context establishes a connection to the nearest 'scaffold' ..
              // or to the nearest 'widget' that controlles the page we're seeing .. a.k.a the 'scaffold()'
              savedScaffold.showSnackBar(SnackBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                // backgroundColor: Theme.of(context).colorScheme.onBackground,
                elevation: 4,
                // what gets shown on the snackbar.
                content: Row(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(50),
                    height: 30,
                    width: 7.0,
                    color: (_hasError[0] == true)
                        ? savedTheme.errorColor
                        : savedTheme.primaryColor,
                  ),
                  //offline_pin,beenhere
                  SizedBox(
                    width: 7,
                  ),
                  Icon(
                    Icons.ac_unit,
                    size: 18,
                    color: savedTheme.primaryColor,
                    // Theme.of(context).colorScheme.primary
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  if (_hasError[0] == true)
                    Text('Something went wrong.')
                  else
                    Text('Item Deleted Successfully.')
                ]),
                // the duration on snackbar
                duration: Duration(milliseconds: 2000),
                // the actions I can perform on the 'snackbar'
                action: (_hasError[0] == true)
                    ? null
                    : SnackBarAction(
                        label: 'Undo',
                        onPressed: () =>
                            Provider.of<Pictures>(context, listen: false)
                                .mAddPicture(
                                    picture: picture, identifier: 'Restore'),
                      ),
              ));
            }
          }
        });
  }
}
