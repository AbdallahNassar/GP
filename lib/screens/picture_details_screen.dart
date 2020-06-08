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
    // 'modalRoute' to extract the Arguments passed via the routes
    final routeArgument = ModalRoute.of(context).settings.arguments as String;

    // this is to set this class a 'listener' to the 'provider' that is defined in the 'provider' folder.
    // the 'listen' argument is used to just tap into the provider once when this class is created and
    // then DO NOT change whenever the provider data changes .. as if I add another picture and
    // I were in a certain picture list then NOTHING should change for me and I should not rebuild
    // my picture view.
    final picturesProvider = Provider.of<Pictures>(context, listen: false);

    // now I search the 'list' in the 'provider' for the element with the ID sent to my via the route
    // to dynamically retrieve All the picture details instead of passing it around.
    final Picture pictureData = picturesProvider.mFindByID(routeArgument);

    // 'safearea' to respect any notches or shoit
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          // A list of 'widgets' to scroll through
          slivers: <Widget>[
            SliverAppBar(
              // centerTitle: true,
              elevation: 4.0,
              // the height it will have if it's NOT the 'appbar'
              expandedHeight: 300,
              // should the appbar remail visibile after you scroll down ?
              pinned: true,
              // our new appbar details
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color: Theme.of(context).accentColor.withAlpha(150),
                  ),
                  padding: const EdgeInsets.only(
                    right: 9.0,
                    left: 9.0,
                    bottom: 2.0,
                  ),
                  child: Text(
                    pictureData.title,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                // what to see if the 'appbar' is expanded
                background: Hero(
                  // 'tag' to identify the 'widget' that I wish to animate .. should be unique
                  tag: pictureData.id,
                  child: Image.asset(
                    pictureData.imageURI,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // the rest of the stuff in the screen
            SliverList(
              // 'delegate' to tell flutter how to render the content of the list
              // 'SliverChildListDelegate' takes a list of items that will not be in the sliver
              delegate: SliverChildListDelegate(
                [
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black54,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      pictureData.extractedText,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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

// // for a floating custom shape/color container to be put anywhere
// class TitleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//      var path = Path();
//      path.lineTo(size.width - 20, 0)
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
