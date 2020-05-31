import 'package:flutter/material.dart';
import '../widgets/custom_app_drawer.dart';

class TestScreen extends StatelessWidget {
  // ========================== class parameters ==========================
  static const routeName = '/test';
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 15,
            child: CircularProgressIndicator(
              semanticsLabel: 'HA',
              semanticsValue: 'hae',
              // strokeWidth: 4,
            ),
          ),
        ),
      ),
    );
  }
}
