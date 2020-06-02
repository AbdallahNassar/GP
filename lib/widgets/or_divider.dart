import 'package:flutter/material.dart';

class ORDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      width: deviceSize.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.blueGrey,
              height: 5,
            ),
          ),
          Text(
            'OR',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: Divider(
              color: Colors.blueGrey,
              height: 5,
            ),
          ),
        ],
      ),
    );
  }
}
