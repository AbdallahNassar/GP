import 'package:ScaniT/widgets/home_grid.dart';
import 'package:flutter/material.dart';

class LowerHomeScreen extends StatefulWidget {
  var seeFavs = false;
  @override
  _LowerHomeScreenState createState() => _LowerHomeScreenState();
}

class _LowerHomeScreenState extends State<LowerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // ========================== class parameters ==========================

    final deviceSize = MediaQuery.of(context).size;
    // ======================================================================
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Pictures',
              style: Theme.of(context).textTheme.headline3,
            ),
            InkWell(
              // to rebuild the widget on button click
              onTap: () {
                setState(() {
                  widget.seeFavs = !widget.seeFavs;
                });
              },
              child: Text(
                widget.seeFavs == true ? 'See All' : 'See Favourites',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Color(0xFF6E8AFA),
                      fontSize: 17,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: deviceSize.height * 0.04,
        ),
        // routename to customize empty list message.
        // flexible to medigate column error .. to restrain it.
        Expanded(
          child: widget.seeFavs == true
              ? HomeScreenGrid(routeName: '/favourites')
              : HomeScreenGrid(routeName: '/'),
        ),
      ],
    );
  }
}
