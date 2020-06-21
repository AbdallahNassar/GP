import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static String routeName = 'df';
  final PlaceLocation initialLocation;
  final bool isSelecting;
  // ========================== class constructor ==========================
  MapScreen({
    // the initial location on the map
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
    // this should be false as we only view it in READ_ONLY mode so to say.
    this.isSelecting = false,
  });
  // ===================================================================

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ========================== class parameters ==========================
  // this will be the user selected location on the map.
  LatLng _pickedLocation;
  // ========================== class methods ==========================
  // the will be called when the user taps on a place
  // the 'position' argument is automatically provided by google.
  void _selectLocation(LatLng position) {
    // to rebuild the screen and put a 'marker' where the user pressed.
    setState(() {
      _pickedLocation = position;
    });
  }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Location'),
        actions: <Widget>[
          // only show the checkmark in 'selecting' mode
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              // the icon does noting if a location if not selected
              onPressed: (_pickedLocation == null)
                  ? null
                  : () {
                      // pop this screen and return some data to the calling screen.
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      // Widget to display google map in
      body: GoogleMap(
        // initial location visible on the map
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          // zoom lvl
          zoom: 16,
        ),
        // if In selecting mode + user tapped, do something
        onTap: widget.isSelecting ? _selectLocation : null,
        // the red icon that appeard on the location on the map
        // show it if we are on the Map screen AND in selecting mode, i.e. not viewing it
        // from the details screen
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                // to show the 'm1' label on the choosen position on the map
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
