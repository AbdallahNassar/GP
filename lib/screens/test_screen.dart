import 'package:flutter/material.dart';
import '../widgets/flare_button.dart';

// flare widgets must be statful, duh!
class TestScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static String routeName = '/test';
  // ======================================================================

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
