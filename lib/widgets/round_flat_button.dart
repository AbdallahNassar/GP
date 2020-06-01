import 'package:ScaniT/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RoundFlatButton extends StatelessWidget {
  // ========================== class parameters ==========================
  final String text;
  final Function function;
  final Color textColor, backgnColor;

  // ========================== class constructor ==========================
  const RoundFlatButton({
    Key key,
    @required this.deviceSize,
    @required this.text,
    @required this.function,
    @required this.textColor,
    @required this.backgnColor,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      width: deviceSize.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          color: backgnColor,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: () => function(context, LoginScreen.routeName),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
