import 'package:ScaniT/screens/welcome_screen.dart';
import 'package:ScaniT/widgets/lowerHomeWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/globals.dart';
import '../widgets/home_speed_dial.dart';
import '../providers/pictures_provider.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/home_grid.dart';
import '../providers/authentication_provider.dart';

class HomeScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/home-page';
  // var seeFav = false;
  // ========================== class constructor ==========================
  const HomeScreen({Key key}) : super(key: key);
  // =========================== class methods ============================
  // 'async' to return a 'future' and 'awaits' to allow that that I can wait for this
  //  to finish executing before I move onto the next code .
  Future<void> _mReFetchData(context) async {
    try {
      print('fetching form home');
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
  // '_' at the beginning of the name to indicate that this is a private method
  // and should not be called from outside of this class.
  void _handleLogout(context) {
    Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    final authProvider = Provider.of<Authentication>(context, listen: false);
    authProvider.mLogOut();
  }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ==========================
    // final GlobalKey<ScaffoldState> homeScaffoldKey =
    //     new GlobalKey<ScaffoldState>();

    // go get device dimensions
    final deviceSize = MediaQuery.of(context).size;
    // to get user name and picture.
    final authProvider = Provider.of<Authentication>(context, listen: false);
    // ======================================================================

    return Scaffold(
      // key to be used in custom delete icon.
      key: myGlobals.homeScaffoldKey,
      // 'PreferredSize' to change the size of the appbar
      appBar: PreferredSize(
        // set the size to 120 px in height approximately.
        preferredSize: Size.fromHeight(deviceSize.height * 0.17),
        child: AppBar(
          // to remove the build in 'show drawer' iconbutton
          automaticallyImplyLeading: false,
          // to get the flat look
          backgroundColor: Colors.white,
          elevation: 0,
          // builder to enabel drawer opening with a press on the icon butotn.
          // 'flexiblespace' to change the positiong of the items in it freely.
          flexibleSpace: Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: SvgPicture.asset(
                      'assets/icons/menu.svg',
                    ),
                  ),
                  Spacer(),
                  // to rotate the logout icon
                  RotationTransition(
                    turns: AlwaysStoppedAnimation(15 / 360),
                    child: IconButton(
                      // onPressed: () => _handleLogout(context),
                      onPressed: () => // show the confirmation Dialogue.
                          showDialog(
                              context: context,
                              // the shown dialog will be an 'alert Dialog'
                              builder: (builderContext) => AlertDialog(
                                    // title of the 'alerDialog'
                                    title: Text(
                                      'Are you sure?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // body of the 'alertDialog'
                                    content: Text(
                                      'Do you want to logout?',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('No'),
                                        // Returns a [Future] that resolves to the value (if any) that was passed
                                        // to [Navigator.pop] when the dialog was closed.
                                        onPressed: () =>
                                            Navigator.of(builderContext)
                                                .pop(false),
                                      ),
                                      FlatButton(
                                        child: Text('Yes'),
                                        // Returns a [Future] that resolves to the value (if any) that was passed
                                        // to [Navigator.pop] when the dialog was closed.
                                        onPressed: () =>
                                            Navigator.of(builderContext)
                                                .pop(true),
                                      )
                                    ],
                                    // the 'then' fuction will be executed AFTER I choose from the 'shown Dialogue'
                                    // hence the name .. Future.
                                  )).then(
                        (answer) {
                          // If the user confirms the logout.
                          if (answer != null && answer == true)
                            _handleLogout(context);
                        },
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/logout5.svg',
                        color: Color(0xFFA0A5BD),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  CircleAvatar(
                    backgroundImage: authProvider.userName == 'there'
                        ? AssetImage(authProvider.userPicURI)
                        // to handle some error with user pic
                        : NetworkImage(authProvider.userPicURI ??
                            'https://www.google.com/imgres?imgurl=https%3A%2F%2Fimg.favpng.com%2F7%2F0%2F8%2Fscalable-vector-graphics-avatar-learning-icon-png-favpng-FYEDPnnsy3wDHTyMzJa3qhE7f_t.jpg&imgrefurl=https%3A%2F%2Ffavpng.com%2Fpng_search%2Fuser-avatar&tbnid=zJIfwvV63CX7DM&vet=12ahUKEwj__LGglpLrAhX1wQIHHT49A9wQMygAegUIARDMAQ..i&docid=tYmtVCeRsniMNM&w=290&h=241&q=user%20avatar%20png&ved=2ahUKEwj__LGglpLrAhX1wQIHHT49A9wQMygAegUIARDMAQ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _mReFetchData(context),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                            'Search in Pictures',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFA0A5BD),
                            ),
                          ),
                        ),
                        Spacer(flex: 7),
                      ],
                    )),
                // TO ONLY REBUILD THIS TO SHOW THE FAVS.
                Expanded(
                  child: LowerHomeScreen(),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: HomeSpeedDial(),
    );
  }
}
