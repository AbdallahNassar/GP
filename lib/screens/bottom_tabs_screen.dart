import './update_image_screen.dart';

import '../widgets/custom_app_drawer.dart';
import './home_page_screen.dart';
import './favourites_screen.dart';
import 'package:flutter/material.dart';

class BottomTapsScreen extends StatefulWidget {
  @override
  _BottomTapsScreenState createState() => _BottomTapsScreenState();
}

// the 'bottom tab bar' must be a 'stateful widget'.
class _BottomTapsScreenState extends State<BottomTapsScreen> {
  // class parameters
  List<Map<String, Object>> _screensList;

  int _selectedScreenIndex = 0;

  //class methods
  @override
  // this is in oreder to allow for the 'widget.fave.....' to work.
  // because I have to be inside of some specific state to have that functionality
  void initState() {
    _screensList = [
      {'screen': HomePageScreen(), 'title': 'ScaniT'},
      {'screen': FavouritesScreen(), 'title': 'Your Favoutire Items'}
    ];
    super.initState();
  }

  // 'index' parameter is AUTOMATICALLY provided by 'flutter' :)
  void _mSelectedTab(index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(UpdatePictureScreen.routeName),
            icon: Icon(
              Icons.add,
              size: 25,
              color: Theme.of(context).textTheme.button.color,
            ),
          )
        ],
        title: Text(_screensList[_selectedScreenIndex]['title']),
      ),
      // 'Drawer' is to create that 'hamburger icon' at the 'appbar'
      drawer: CustomAppDrawer(),
      body: _screensList[_selectedScreenIndex]['screen'],
      // 'bottomNavigationBar' is the 'bottom tab bar'
      bottomNavigationBar: BottomNavigationBar(
        // 'onTab' to control what happens when the use presses a certain tabBar item.
        onTap: _mSelectedTab,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        // 'type' is responsible for the 'tab' changing animation.
        type: BottomNavigationBarType.shifting,
        // the 'currentIndex' tells the 'bottomNavigationBar' which 'tab' is selected and is the reason for
        // the transition between screens 'effect' + the selected 'screen' changing color
        currentIndex: _selectedScreenIndex,
        // 'BottomNavigatrionBarItem' is the 'tab bar icon' to be displayed.
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.home),
              title: Text('Home Page')),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.star),
              title: Text('Favourites'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Open the 'UpdatePicture Screen'.
        onPressed: () =>
            Navigator.of(context).pushNamed(UpdatePictureScreen.routeName),
        child: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).textTheme.button.color,
        ),
      ),
    );
  }
}
