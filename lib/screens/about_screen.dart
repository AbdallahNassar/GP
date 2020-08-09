import 'package:flutter/material.dart';
import '../widgets/custom_app_drawer.dart';

class AboutScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/about';
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        drawer: CustomAppDrawer(),
        body: SafeArea(
            child: Center(
          child: Text(
            'About Us.',
            style: Theme.of(context).textTheme.headline3,
          ),
        )));
  }
}
