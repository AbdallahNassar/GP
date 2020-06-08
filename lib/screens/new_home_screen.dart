import '../providers/pictures_provider.dart';
import '../widgets/custom_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/new_home_grid.dart';
import '../providers/authentication_provider.dart';

class NewHomeScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/new-home-page';
  // ========================== class constructor ==========================
  const NewHomeScreen({Key key}) : super(key: key);
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
    // ========================== class parameters ==========================
    // go get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    // to get user name and picture.
    final authProvider = Provider.of<Authentication>(context, listen: false);
    // ======================================================================

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _mReFetchData(context),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/menu.svg',
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: authProvider.userName == 'there'
                          ? AssetImage(authProvider.userPicURI)
                          : NetworkImage(authProvider.userPicURI),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceSize.height * 0.04,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Hey ${authProvider.userName},\n',
                            style: Theme.of(context).textTheme.headline2),
                        TextSpan(
                            text: 'Seatch for a picture with it\'s title',
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    width: double.infinity,
                    height: deviceSize.height * 0.076,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xFFF5F5F7),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        SvgPicture.asset('assets/icons/search.svg'),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Search for pictures',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFA0A5BD),
                            ),
                          ),
                        ),
                        Spacer(flex: 7),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      'See All',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Color(0xFF6E8AFA)),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceSize.height * 0.04,
                ),
                // routename to customize empty list message.
                HomeScreenGrid(routeName: '/')
              ],
            ),
          ),
        ),
      ),
    );
  }
}