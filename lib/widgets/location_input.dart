import 'package:ScaniT/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  // ========================== class parameters ==========================
  final Function onSelectPlace;
  final PlaceLocation initialLocation;

  // ========================== class constructor ==========================
  LocationInput({this.onSelectPlace, this.initialLocation});
  // ===================================================================
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // ========================== class parameters ==========================
  String _previewImageUrl;
  // to show a loading bar while the I fetch the location.
  var _isLoading = false;
  // ========================== class methods ==========================
  // to show a preview of the initial location once the widget is built
  @override
  void didChangeDependencies() {
    if (widget.initialLocation != null)
      _showPreview(
          widget.initialLocation.latitude, widget.initialLocation.longitude);
    super.didChangeDependencies();
  }

  // shows a snapshot of the current location on google maps.
  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _isLoading = false;
      _previewImageUrl = staticMapImageUrl;
    });
  }

  // ===================================================================
  // get's the user current loactaion through the 'location' package
  Future<void> _getCurrentUserLocation() async {
    try {
      // setstate to show a loading spinner
      setState(() {
        _isLoading = true;
      });
      // get user location .. latitude and longitude
      final locData = await Location().getLocation();

      // show a preview of the location in the box
      _showPreview(locData.latitude, locData.longitude);
      // call the function that will save that data into database
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      print('user cancelled the permission');
      return;
    }
  }

// ===================================================================
  // choose a location on map .. using a 'future' and 'async' to get the data
  // form the called screen and save it into the database.
  Future<void> _selectOnMap() async {
    // the 'selectedLocation' will be returned when I pop the screen.
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      // using material route to pass data through the widget's constructor.
      MaterialPageRoute(
        // to change the opening animation and show a 'X' button on top
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    // if the user closed the map w/o choosing anything.
    if (selectedLocation == null) {
      return;
    }
    print('selected loc lati = == = = = = ${selectedLocation.latitude}');
    // show a preview of the selceted location on the preview box.
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    // call the function that will save that data into database
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // show a progrss indicator while I fetch the location from Maps API.

        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: (_isLoading == true)
              ? CircularProgressIndicator()
              : _previewImageUrl == null
                  ? Text(
                      'No Location Chosen',
                      textAlign: TextAlign.center,
                    )
                  : Image.network(
                      _previewImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
