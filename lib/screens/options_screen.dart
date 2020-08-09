import '../widgets/custom_app_drawer.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  // -============================= Class Parameters =============================-
  // 'routeName' to be used in the routing table to help with the screen selection.
  static const routeName = '/options';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      drawer: CustomAppDrawer(),
      body: Center(
        child: Text(
          'h',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
