import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/picture_provider.dart';
import '../screens/update_image_screen.dart';
import '../widgets/custom_delete_icon.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PictureSpeedDial extends StatelessWidget {
  // ========================== class parameters ==========================
  final Picture pictureData;
  // ========================== class constructor ==========================
  const PictureSpeedDial({
    Key key,
    this.pictureData,
  }) : super(key: key);
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ==========================
    // tapping into the 'auth' provider to access it's variables.
    final authProvider = Provider.of<Authentication>(context, listen: false);
    return SpeedDial(
      closeManually: false,
      // opacity of overlay screen,
      overlayOpacity: 0.5,
      // to animate the main flating button
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).accentColor,
      children: [
        // each one is a floating action button.. from bottom to top
        SpeedDialChild(
          onTap: () => Navigator.of(context)
              .pushNamed(UpdatePictureScreen.routeName, arguments: pictureData),
          child: Icon(
            Icons.edit,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Colors.white,
          elevation: 5,
          labelStyle: Theme.of(context).textTheme.caption,
          label: 'Edit',
        ),
        SpeedDialChild(
          child: Consumer<Picture>(
            builder: (_, item, child) => IconButton(
              alignment: Alignment.center,
              icon: Icon(
                //  check to see if it's favourite on not and show the appropriate icon based on that.
                item.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).primaryColor,
                // this how i'd refrence the 'child' widget that I created in comments below.
                // label: child
              ),
              onPressed: () => item.mToggleFavourite(
                  authToken: authProvider.authToken,
                  userID: authProvider.userID),
            ),
          ),
          elevation: 5,
          labelStyle: Theme.of(context).textTheme.caption,
          label: 'Favoutire',
          backgroundColor: Colors.white,
          onTap: () {},
        ),
        SpeedDialChild(
          elevation: 5,
          child: CustomDeleteIcon(
            picture: pictureData,
          ),
          labelStyle: Theme.of(context).textTheme.caption,
          label: 'Delete',
          backgroundColor: Colors.white,
          onTap: () {},
        ),
      ],
    );
  }
}
