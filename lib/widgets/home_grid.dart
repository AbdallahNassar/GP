import '../widgets/picture_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/pictures_provider.dart';
import 'package:provider/provider.dart';

import './empty_list.dart';

class HomeScreenGrid extends StatelessWidget {
  // ========================== class parameters ==========================
  final String routeName;
  // ========================== class constructor ==========================
  HomeScreenGrid({this.routeName});

  // ================================================================

  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ========================
    // go get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    // ==================================================================

    return FutureBuilder(
      // just tap into the provider and call the function .. listen to false to not build the widget here..
      // but below after I've made sure that I have NO data .. then I tap into that data and build my widget.
      // the future to which it should listen..
      future: Provider.of<Pictures>(context, listen: false).mFetchData(),
      // to handle my different future states.
      builder: (_, dataSnapShot) {
        // the data is still loading  .. show the spinner
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Container(
            height: deviceSize.height * 0.5,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          );
          // Data is Fetched ..
        } else {
          // there's some error in my data.
          if (dataSnapShot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }
          // there's NO error in my data.
          else {
            return Consumer<Pictures>(
              builder: (_, picturesProvider, child) {
                // I'm rendering the items in the 'home screen'
                if (routeName == '/') {
                  // I should check the 'pictureList' which has all the pictures
                  if (picturesProvider.pictureList.isEmpty) {
                    print('empty');
                    return EmptyList(
                      title: 'Start Adding Pictures Now!',
                    );
                  }
                }
                // I'm rendering the items in the 'favourite screen'
                else {
                  if (picturesProvider.favouritepicturesList.isEmpty) {
                    return EmptyList(
                      title: 'Start Favouriting Pictures Now!',
                    );
                  }
                }
                // the lists are NOT empty so I should start getting the data and build it.
                return StaggeredGridView.countBuilder(
                  itemCount: (routeName == '/')
                      ? picturesProvider.pictureList.length
                      : picturesProvider.favouritepicturesList.length,
                  crossAxisCount: 2,
                  crossAxisSpacing: deviceSize.width * 0.04,
                  mainAxisSpacing: deviceSize.height * 0.017,
                  staggeredTileBuilder: (i) => StaggeredTile.fit(1),
                  itemBuilder: (ctx, itemIndex) => ChangeNotifierProvider.value(
                    // here I return a 'picture' instead of creating one like 'picture()' because it was already created
                    // when I created my 'picture(((S)))' provider earlier in the main where I needed it and that was the
                    // top most place where I needed it.
                    value: (routeName == '/')
                        ? picturesProvider.pictureList[itemIndex]
                        : picturesProvider.favouritepicturesList[itemIndex],
                    // it would be okay here to pass the data to another 'widget' in the constructor as I need it and want to
                    // display it there .. so this is the preferred practise .. but providers are used to prevent having to
                    // pass arguments to a 'widget' that will NOT use these arguments but simply forward them to it's child or smth.
                    // child: pictureItem(picture: picturesList[itemIndex])));

                    // BUT I then changed my logic and now I want to know dynamically the values of a given picture .. so I created
                    // a provider and will use that to get my data from.

                    child: PictureItem(index: itemIndex),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 10.0, vertical: 10.0),
                    //   child: Text(
                    //     'Image Title',
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .headline3
                    //         .copyWith(
                    //             fontFamily: 'Lobster',
                    //             fontWeight: FontWeight.w300),
                    //   ),
                    // ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
