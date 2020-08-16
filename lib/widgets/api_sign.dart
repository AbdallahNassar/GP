import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';

class APISign extends StatelessWidget {
  // ========================== class methods ==========================
  // show a dialog if there's an error in the authentication process.
  void _showSnackBar(context, {String errorMessage = 'ERROR'}) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          margin: const EdgeInsets.only(
            left: 20,
          ),
          child: Text(errorMessage),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // // show a dialog if there's an error in the authentication process.
  // void _showErroDialog(context, {String errorMessage = 'ERROR'}) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: Text('An Error Occurred!'),
  //             content: Text(errorMessage ??
  //                 'Could not authenticate you. Please try again later.'),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Ok'),
  //                 onPressed: () => Navigator.of(ctx).pop(),
  //               )
  //             ],
  //           ));
  // }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async {
            try {
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'singInWithGoogle');
              Navigator.of(context).pushNamed('/');
            } catch (error) {
              _showSnackBar(context, errorMessage: error.message);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 2),
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/google-plus.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        SizedBox(
          width: deviceSize.width * .03,
        ),
        InkWell(
          onTap: () async {
            try {
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'singInWithFacebook');
              Navigator.of(context).pushNamed('/');
            } catch (e) {
              print(e.message);
              _showSnackBar(context, errorMessage: e.message);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 2),
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/facebook.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            try {
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'Anon');
              Navigator.of(context).pushNamed('/');
            } catch (e) {
              _showSnackBar(context, errorMessage: e.message);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 2),
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/detective.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
      ],
    );
  }
}
