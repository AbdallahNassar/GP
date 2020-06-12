import 'package:ScaniT/helpers/globals.dart';
import 'package:ScaniT/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_speed_dial.dart';
import '../providers/picture_provider.dart';
import '../providers/pictures_provider.dart';

class PictureDetails extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/picture-details-screen';

  @override
  Widget build(BuildContext context) {
    // 'modalRoute' to extract the Arguments passed via the routes
    final routeArgument = ModalRoute.of(context).settings.arguments as String;

    final picturesProvider = Provider.of<Pictures>(context, listen: false);

    // now I search the 'list' in the 'provider' for the element with the ID sent to my via the route
    // to dynamically retrieve All the picture details instead of passing it around.
    final Picture pictureData = picturesProvider.mFindByID(routeArgument);
    print('picture DATA = $pictureData');
    // to avoid deletions[w/o restoration] error.
    if (pictureData == null)
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    final index = picturesProvider.pictureList.indexOf(pictureData);
    if (index == -1)
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );

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
          floatingActionButton: CustomSpeedDial(pictureData: pictureData),
        ),
      ),
    );
  }
}
