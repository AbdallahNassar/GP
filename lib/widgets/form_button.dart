import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  // ========================== class parameters ==========================
  final String text;
  final bool isLoading;
  final Function submitMethod;
  // ========================== class constructor ==========================
  FormButton({this.isLoading, this.text, this.submitMethod});
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return (isLoading)
        ? Column(
            children: <Widget>[
              SizedBox(
                height: deviceSize.height * 0.03,
              ),
              SizedBox(
                  height: deviceSize.height * 0.03,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )),
            ],
          )
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 14.0),
            width: deviceSize.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                onPressed: () => submitMethod(),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
  }
}
