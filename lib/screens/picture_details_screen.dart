import './update_image_screen.dart';

import '../providers/picture_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pictures_provider.dart';

class PictureDetails extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/picture-details-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // 'modalRoute' to extract the Arguments passed via the routes
    final routeArgument = ModalRoute.of(context).settings.arguments as String;

    // this is to set this class a 'listener' to the 'provider' that is defined in the 'provider' folder.
    // the 'listen' argument is used to just tap into the provider once when this class is created and then
    // DO NOT change whenever the provider data changes .. as if I add another picture and I were in a certain
    // picture list then NOTHING should change for me and I should not rebuild my picture view.
    final picturesProvider = Provider.of<Pictures>(context, listen: false);

    // now I search the 'list' in the 'provider' for the element with the ID sent to my via the route
    // to dynamically retrieve All the picture details instead of passing it around.
    final Picture pictureData = picturesProvider.mFindByID(routeArgument);

    // 'safearea' to respect any notches or shoit
    return Scaffold(
      appBar: AppBar(
        title: Text(pictureData.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.border_color,
              color: Theme.of(context).textTheme.button.color,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
                UpdatePictureScreen.routeName,
                arguments: pictureData),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: deviceSize.height * 0.4,
            child: Hero(
              tag: pictureData.id,
              child: Image.asset(
                pictureData.imageURI,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              pictureData.extractedText,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        // Open the 'UpdatePicture Screen'.
        onPressed: () => Navigator.of(context)
            .pushNamed(UpdatePictureScreen.routeName, arguments: pictureData),
        child: Icon(
          Icons.border_color,
          size: 24,
          color: Theme.of(context).textTheme.button.color,
        ),
      ),
    );
  }
}
