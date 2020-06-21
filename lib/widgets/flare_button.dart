import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class FlareButton extends StatefulWidget {
  @override
  _FlareButtonState createState() => _FlareButtonState();
}

class _FlareButtonState extends State<FlareButton> {
  // ========================== class parameters ==========================
  // to control the animation playback
  bool _isOpen = false;
  // the dimentions are provide in the '.flr' asset .
  static const double AnimationHeight = 150.0;
  static const double AnimationWidth = 150.0;

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: AnimationHeight,
      width: AnimationWidth,
      color: Theme.of(context).primaryColor,
      child: GestureDetector(
        // handles the tap while the animation is open
        onTapUp: (tapInfo) {
          setState(() {
            // this gets me the local position (coordinates) of the user tap
            var localTouchPos = (context.findRenderObject() as RenderBox)
                .globalToLocal(tapInfo.globalPosition);
            // where did the user touch ?
            var topHalf = localTouchPos.dy < AnimationHeight / 2;
            var leftSide = localTouchPos.dx < AnimationWidth / 3;
            var rightSide = localTouchPos.dx > (AnimationWidth / 3) * 2;
            // check if user pressed on the top half and handle the icon, left or right
            if (leftSide && topHalf)
              print('top left');
            else if (rightSide && topHalf)
              print('top right');
            // the user pressed on the bottm half, show/hide the animation
            else {
              if (_isOpen)
                print('close bottom');
              else
                print('open boottm');
            }
            // close the animation
            _isOpen = !_isOpen;
          });
        },
        // the Animator controller, just provide the asset
        child: FlareActor(
          'assets/flare/button.flr',
          animation: _isOpen ? 'activate' : 'deactivate',
        ),
      ),
    );
  }
}
