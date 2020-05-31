import '../providers/picture_provider.dart';
import './picture_item.dart';
import '../providers/pictures_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './empty_list.dart';

// I seperate this class from the above one because I don't need to rebuld all the above class
// I don't need to rebuild the 'appbar' and 'scaffold' .. so this should improve performance and resources usage
class HomeGrid extends StatelessWidget {
  // ========================== class parameters ==========================
  final String routeName;

  // ========================== class constructor ==========================
  HomeGrid({this.routeName});

  // =========================== class methods ============================
  // 'async' to return a 'future' and 'awaits' to allow that that I can wait for this
  //  to finish executing before I move onto the next code .
  Future<void> _mReFetchData(context) async {
    try {
      await Provider.of<Pictures>(context, listen: false).mFetchData();
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(
                  'An error occured!',
                  textAlign: TextAlign.center,
                ),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
      // handle what happens when the fetching is successful and completed.
    }
  }

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    // 'FutureBuilder' takes a future and automatically starts listen to that future .. so it adds 'then' and 'onerror'
    // methods automatically for you .. the 'builder' takes a 'snapShot' of your 'future'
    // and based on that(the state of the future you're listening to) it BUILDS different things on the screen ..
    // whether it be a 'spinner' for loading or 'emptyList image' or the thing you're waiting on.
    return FutureBuilder(
      // just tap into the provider and call the function .. listen to false to not build the widget here..
      // but below after I've made sure that I have NO data .. then I tap into that data and build my widget.
      // the future to which it should listen..
      future: Provider.of<Pictures>(context, listen: false).mFetchData(),
      // to handle my different future states.
      builder: (_, dataSnapShot) {
        // the data is still loading  .. show the spinner
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
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
                return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    // 'Sliver' is a scrollable area on the screen
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // max item width is 200 pixels
                        crossAxisCount: 2,
                        // the ratio between width and height
                        childAspectRatio: 1.5,
                        // the spacing between the grid items
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16),
                    itemCount: (routeName == '/')
                        ? picturesProvider.pictureList.length
                        : picturesProvider.favouritepicturesList.length,
                    // I could only use 'ChangeNotifierProvider' here but the '.value' constructor is BEST suited when you
                    // are 'providing' your data with single Lists or grids items .. so that flutter can recycle the 'widget' that's
                    // attached to the provider .. and 'ChangeNotifierProvider' cleans up the data in memory to avoid memory Leaks.
                    itemBuilder: (ctx, itemIndex) =>
                        ChangeNotifierProvider.value(
                            // here I return a 'picture' instead of creating one like 'picture()' because it was already created
                            // when I created my 'picture(((S)))' provider earlier in the main where I needed it and that was the
                            // top most place where I needed it.
                            value: (routeName == '/')
                                ? picturesProvider.pictureList[itemIndex]
                                : picturesProvider
                                    .favouritepicturesList[itemIndex],
                            // it would be okay here to pass the data to another 'widget' in the constructor as I need it and want to
                            // display it there .. so this is the preferred practise .. but providers are used to prevent having to
                            // pass arguments to a 'widget' that will NOT use these arguments but simply forward them to it's child or smth.
                            // child: pictureItem(picture: picturesList[itemIndex])));

                            // BUT I then changed my logic and now I want to know dynamically the values of a given picture .. so I created
                            // a provider and will use that to get my data from.
                            child: PictureItem()));
              },
            );
          }
        }
      },
    );
  }
}
