import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/picture_provider.dart';
import '../screens/picture_details_screen.dart';
import './custom_delete_icon.dart';

class PictureItem extends StatelessWidget {
  // ========================== class parameters ==========================
  final int index;
  // ========================== class constructor ==========================
  PictureItem({this.index});

  // ================================================================
  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ========================
    // go get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    // ==================================================================

    // this line is to 'listen' to the 'provider' of 'picture' to get data from it and
    // NOT be NOTIFIED when that data changes to rebuild the widget because of the 'listen' att.
    // here I just want to extract data from the provider ONCE at the beginning but don't care
    // for any further updates .. ONLY PARTS of this 'widget' 'tree' is interested in that ..
    // and THESE parts I wrap with the 'Consumer widget' .. all that is to imporve performance and
    // REBUILD ONLY THE ABSOLUTELY NECESSARY PARTS OF MY WIDGET TREE.
    final picture = Provider.of<Picture>(context, listen: false);

    // 'GridTile' is a 'Widget' that can be built anywhere but workd particularly well inside a 'Grid'
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        children: <Widget>[
          Container(
            height: index.isEven
                ? deviceSize.height * 0.25
                : deviceSize.height * 0.3,
            width: deviceSize.width * 0.6,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                // TODO: convert to network image,
                image: AssetImage(picture.imageURI),
                fit: BoxFit.fill,
              ),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(PictureDetails.routeName, arguments: picture.id),
              child: Hero(
                tag: picture.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/oops.jpg'),
                  image: AssetImage(picture.imageURI),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Text(
              picture.title,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontFamily: 'Lobster', fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
