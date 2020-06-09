import '../screens/update_image_screen.dart';
import '../widgets/custom_delete_icon.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../providers/picture_provider.dart';
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
    // tapping into the 'auth' provider to access it's variables.
    final authProvider = Provider.of<Authentication>(context, listen: false);

    final picturesProvider = Provider.of<Pictures>(context, listen: false);

    // now I search the 'list' in the 'provider' for the element with the ID sent to my via the route
    // to dynamically retrieve All the picture details instead of passing it around.
    final Picture pictureData = picturesProvider.mFindByID(routeArgument);
    final index = picturesProvider.pictureList.indexOf(pictureData);
    // if (index == -1) return null;

    // 'safearea' to respect any notches or shoit
    // creating a provider of 'picture' to access it and change it's fav
    return ChangeNotifierProvider.value(
      value: picturesProvider.pictureList[index], //change builder to create
      child: Consumer<Picture>(
        builder: (context, provider, child) => Scaffold(
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
                      vertical: 10,
                    ),
                    title: Container(
                      constraints: BoxConstraints(maxHeight: 60),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Colors.black,
                        // ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.2),
                      ),
                      padding: const EdgeInsets.only(
                        right: 9.0,
                        left: 9.0,
                        bottom: 2.0,
                      ),
                      child: Text(
                        pictureData.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.w400,
                              fontSize: 23,
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
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(0.3),
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
          // 'speed dial' to have an action button that opens other action buttons.
          floatingActionButton: SpeedDial(
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
                onTap: () => Navigator.of(context).pushNamed(
                    UpdatePictureScreen.routeName,
                    arguments: pictureData),
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
                  // 'child' attribute of 'COnsumer' means that the widget in it WILL NOT get rebuild with the rest of
                  // the widgets wrapped in the 'consumer'
                  // child: Text('this item will never change even when this entire widget rebuilds'),
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
          ),
          // floatingActionButton: FloatingActionButton(
          //   // Open the 'UpdatePicture Screen'.
          //   onPressed: () => Navigator.of(context)
          //       .pushNamed(UpdatePictureScreen.routeName, arguments: pictureData),
          //   child: Icon(
          //     Icons.border_color,
          //     size: 24,
          //     color: Theme.of(context).textTheme.button.color,
          //   ),
          // ),
          // ModalRoute.of(context).settings.name.toString() ==
          //                   '/top-tabs' ||
          //               ModalRoute.of(context).settings.name.toString() == '/'
          //           ? CustomDeleteIcon(
          //               picture: picture,
          //               savedScaffold: savedScaffold,
          //               savedTheme: savedTheme,
          //             )
          //           : null,
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
