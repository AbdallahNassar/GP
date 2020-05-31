import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/picture_provider.dart';
import '../screens/picture_details_screen.dart';
import './custom_delete_icon.dart';

class PictureItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // these are saved to be used in the 'custom delete icon' as when I want to show
    // a snackbar inside of a future the 'context' gets mixed up and I can't use it
    // so i'm storing all the data I need now for further need.
    final savedScaffold = Scaffold.of(context);
    final savedTheme = Theme.of(context);
    // this line is to 'listen' to the 'provider' of 'picture' to get data from it and
    // NOT be NOTIFIED when that data changes to rebuild the widget because of the 'listen' att.
    // here I just want to extract data from the provider ONCE at the beginning but don't care
    // for any further updates .. ONLY PARTS of this 'widget' 'tree' is interested in that ..
    // and THESE parts I wrap with the 'Consumer widget' .. all that is to imporve performance and
    // REBUILD ONLY THE ABSOLUTELY NECESSARY PARTS OF MY WIDGET TREE.
    final picture = Provider.of<Picture>(context, listen: false);
    // tapping into the 'auth' provider to access it's variables.
    final authProvider = Provider.of<Authentication>(context, listen: false);

    // 'GridTile' is a 'Widget' that can be built anywhere but workd particularly well inside a 'Grid'
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        // 'child' is the main content of the 'gridtile'
        // 'inkwell' to create the bubble effect and register my press
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(PictureDetails.routeName, arguments: picture.id),
          child: Image.asset(
            picture.imageURI,
            fit: BoxFit.contain,
          ),
        ),

        // the bar at the end of the 'grid tile'
        footer: GridTileBar(
          // 'leading' is the first element to the left
          // 'consumer' to make only the 'child' of it is a LISTENER to changes in the provider
          // and rebuild accordingly.
          leading: Consumer<Picture>(
            builder: (_, item, child) => IconButton(
              icon: Icon(
                //  check to see if it's favourite on not and show the appropriate icon based on that.
                item.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
                // this how i'd refrence the 'child' widget that I created in comments below.
                // label: child
              ),
              onPressed: () => item.mToggleFavourite(
                  authToken: authProvider.authToken,
                  userID: authProvider.userID),
            ),
            // 'child' attribute of 'COnsumer' means that the widget in it WILL NOT get rebuild with the rest of
            // the widgets wrapped in the 'consumer'
            // child: Text('this item will never change even when this entire widget rebuilds'),
          ),
          backgroundColor: Colors.black87,
          // just an ampty string to put some space between the icons.
          title: Text(''),

          // 'trailing' is the most right element in the bar
          // show the 'delete button' only in the 'home screen'
          trailing: ModalRoute.of(context).settings.name.toString() == '/'
              ? CustomDeleteIcon(
                  picture: picture,
                  savedScaffold: savedScaffold,
                  savedTheme: savedTheme,
                )
              : null,
        ),
      ),
    );
  }
}
