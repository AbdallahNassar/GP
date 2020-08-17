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

class HomeScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static const routeName = '/home-page';
  // var seeFav = false;
  var _selected;
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ==========================
    // final GlobalKey<ScaffoldState> homeScaffoldKey =
    //     new GlobalKey<ScaffoldState>();
    List<Map<String, String>> _langMap = [
      {'lang': 'Arabic       ', 'api': '/api/ar'},
      {'lang': 'English       ', 'api': '/api/en'},
    ];
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
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 45),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        'assets/icons/menu.svg',
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 12,
                  ),
                  // // to rotate the logout icon
                  // RotationTransition(
                  //   turns: AlwaysStoppedAnimation(15 / 360),
                  //   child: IconButton(
                  //     // onPressed: () => _handleLogout(context),
                  //     onPressed: () => // show the confirmation Dialogue.
                  //         showDialog(
                  //             context: context,
                  //             // the shown dialog will be an 'alert Dialog'
                  //             builder: (builderContext) => AlertDialog(
                  //                   // title of the 'alerDialog'
                  //                   title: Text(
                  //                     'Are you sure?',
                  //                     textAlign: TextAlign.center,
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                   // body of the 'alertDialog'
                  //                   content: Text(
                  //                     'Do you want to logout?',
                  //                     textAlign: TextAlign.center,
                  //                   ),
                  //                   actions: <Widget>[
                  //                     FlatButton(
                  //                       child: Text('No'),
                  //                       // Returns a [Future] that resolves to the value (if any) that was passed
                  //                       // to [Navigator.pop] when the dialog was closed.
                  //                       onPressed: () =>
                  //                           Navigator.of(builderContext)
                  //                               .pop(false),
                  //                     ),
                  //                     FlatButton(
                  //                       child: Text('Yes'),
                  //                       // Returns a [Future] that resolves to the value (if any) that was passed
                  //                       // to [Navigator.pop] when the dialog was closed.
                  //                       onPressed: () =>
                  //                           Navigator.of(builderContext)
                  //                               .pop(true),
                  //                     )
                  //                   ],
                  //                   // the 'then' fuction will be executed AFTER I choose from the 'shown Dialogue'
                  //                   // hence the name .. Future.
                  //                 )).then(
                  //       (answer) {
                  //         // If the user confirms the logout.
                  //         if (answer != null && answer == true)
                  //           _handleLogout(context);
                  //       },
                  //     ),
                  //     icon: SvgPicture.asset(
                  //       'assets/icons/logout5.svg',
                  //       color: Color(0xFFA0A5BD),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    backgroundImage: authProvider.userPicURI ==
                            'assets/images/avatar.png'
                        ? AssetImage(authProvider.userPicURI)
                        // to handle some error with user pic
                        : NetworkImage(authProvider.userPicURI ??
                            'https://img.favpng.com/7/0/8/scalable-vector-graphics-avatar-learning-icon-png-favpng-FYEDPnnsy3wDHTyMzJa3qhE7f.jpg'),
                  ),
                  Spacer(
                    flex: 1,
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
                          text: 'Choose a language to ',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontSize: 18),
                        ),
                        TextSpan(
                          text: 'ScaniT',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isDense: true,
                                hint: widget._selected == null
                                    ? Text("Select The Language               ")
                                    : Text(_langMap.firstWhere((element) =>
                                        element['api'] ==
                                        widget._selected)['lang']),
                                value: widget._selected,
                                onChanged: (String newValue) {
                                  setState(() {
                                    widget._selected = newValue;
                                  });

                                  print(widget._selected);
                                },
                                items: _langMap.map((map) {
                                  return DropdownMenuItem<String>(
                                    value: map['api'],
                                    // value: _mySelection,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(map['lang'])),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 7,
                        ),
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

      floatingActionButton:
          (widget._selected == null) ? null : HomeSpeedDial(widget._selected),
    );
  }
}
