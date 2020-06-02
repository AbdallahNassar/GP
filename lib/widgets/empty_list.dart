import 'package:flutter/material.dart';

// a widget to be shown if a certain list is empty
class EmptyList extends StatelessWidget {
  // I can use the 'const' keyword here because ALL the class' parameters are 'FINAL'
  // this should save me some performance as I won't have to re-render the entire thing again;
  // for it WILL NOT change (it's position and outter appearance).

  // ========================== class parameters ==========================
  final String title;

  // ========================== class constructor ==========================
  const EmptyList({this.title});
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    // 'LayoutBuilder' is a built-in widget in flutter that returns the context and constraints(dimensions)
    // of the Widget it enveloppes.
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          // a 'container' that defines a boundry around it's child 'like the height
          // aattribute iam using below, I can also use it w/o using the 'child' attribure
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            height: constraints.maxHeight * 0.6,
            // width: constraints.maxWidth * 0.2,
            // height: MediaQuery.of(context).size.height * 0.35,
            child: Image.asset(
              'assets/images/empty_list.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            height: constraints.maxHeight * 0.1,
            child: const Text(
              'YOUR LIST IS\n CURRENTLY EMPTY!\n',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: constraints.maxHeight * .2,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
        ],
      );
    });
  }
}
