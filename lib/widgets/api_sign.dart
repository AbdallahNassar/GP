import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';

class APISign extends StatelessWidget {
  const APISign({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async =>
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'singInWithGoogle'),
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
        InkWell(
          onTap: () async =>
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'singInWithFacebook'),
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
          onTap: () async =>
              await Provider.of<Authentication>(context, listen: false)
                  .mAPILogin(identifier: 'singInWithGoogle'),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 2),
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/icons/twitter.svg',
              height: 20,
              width: 20,
            ),
          ),
        )
      ],
    );
  }
}
