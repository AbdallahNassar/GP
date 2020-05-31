import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drawer_item_model.dart';
import '../providers/authentication_provider.dart';

class DrawerItem extends StatelessWidget {
  // -============================= Class parameters =============================-
  final AppDrawerItemModel drawerItem;
  final String callerRoute;

  // -============================= Class constructor =============================-
  const DrawerItem(this.drawerItem, this.callerRoute);

  // -============================= Class Methods =============================-
  // '_' at the beginning of the name to indicate that this is a private method
  // and should not be called from outside of this class.
  void _handleLogout(context) {
    // to exit the current state and screen before exiting .. so that I avoid the down
    // sides of the 'hard exit' and not anget the compilor :'D
    Navigator.of(context).pop();
    // to always end up on the 'authentication' screen when we logout.
    Navigator.of(context).pushReplacementNamed('/');
    Provider.of<Authentication>(context, listen: false).mLogOut();
  }

  // -=============================================================================-

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // to add horizontal line between items.
        // to NOT Create a line before the first item.
        ListTile(
            leading: drawerItem.icon,
            title: Text(
              drawerItem.title,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
            ),
            onTap: () {
              // handle 'log Out' action has special treatment
              if (drawerItem.title == 'Log Out') {
                _handleLogout(context);
                // hanlde a normal action
              } else {
                // to check what's the current screeen I was viewing before I pressed on the app drawer
                // so that If I press on the same screen that I'm already in .. I simply pop the app drawer
                if (callerRoute == drawerItem.calledRouteName)
                  Navigator.of(context).pop();
                else
                  Navigator.of(context)
                      .pushReplacementNamed(drawerItem.calledRouteName);
              }
            }),
      ],
    );
  }
}
