import 'dart:io';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/choice_box.dart';
import '../widgets/location_input.dart';
import '../models/place_location.dart';
import '../widgets/cancel_raised_button.dart';
import '../providers/pictures_provider.dart';
import '../providers/picture_provider.dart';

class UpdatePictureScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static const routeName = '/update-picture';
  final File chosenPic;
  // for some reason it keeps resending it
  var apiExtText;
  var inApi = false;
  // ========================== class consturctor ==========================
  UpdatePictureScreen({this.chosenPic});
  // ======================================================================
  @override
  _UpdatePictureScreenState createState() => _UpdatePictureScreenState();
}

class _UpdatePictureScreenState extends State<UpdatePictureScreen> {
  // ========================== class parameters ==========================

  //  'GlobalKey' allows us to interact with a 'widget' from inside your code,
  //   so now i can access all the data in the form with this variable.
  final _formHandler = GlobalKey<FormState>();

  // this is to make sure that 'didChangeDependences' only runs once.
  bool _isInitState = true;
  // this is to controll the appearance of the loading screen.
  bool _isLoading = false;
  // to populate the data from the 'form' with this.
  var _pictureTemplate;
  var _arModel = true;
  var _enModel = false;

  // MUST be disposed of after the form terminates .. I added it to Listen to it and when
  // it is changed I reBUild the 'widget' to update the 'image preview'
  // must be disposed of
  final _titleFieldController = TextEditingController();
  // MUST be disposed of after the form terminates
  final _extractedTextFieldFocusNode = FocusNode();

  // to store the location where the image was taken
  PlaceLocation _pickedLocation;

  // ========================== class methods ==========================
  // function that runs after 'init' and before 'build' is executed.
  @override
  void didChangeDependencies() {
    // a check to make sure it only run once
    if (_isInitState) {
      final routeArguments =
          ModalRoute.of(context).settings.arguments as Picture;
      // if 'routeArguments' is null .. then this 'screen' was called to create a NEW 'picture'
      // else it was called to Update an existing 'picture' so save it's existing data in _pictureTemp
      if (routeArguments != null) {
        _pictureTemplate = routeArguments;
        // ONlY the 'imageURL' field should take it's initial value like this cuz of the controller
        // otherwise it explodes in my face.
      } else
        _pictureTemplate = Picture(
            id: null,
            extractedText: '',
            imageURI:
                widget.chosenPic != null ? widget.chosenPic.absolute.path : '',
            title: '',
            isFavourite: false);
      _isInitState = false;
      // call the API with the image with a different thread to start the processing to save time
      // Isolate.spawn((message) {
      //   flaskAPI;
      // }, null);
    }
    super.didChangeDependencies();
  }
// ======================================================================

  @override
  void dispose() {
    // must be MANUALLY dispoded of to avoid memory leaks.
    _titleFieldController.dispose();
    _extractedTextFieldFocusNode.dispose();
    super.dispose();
  }

  // ========================== class methods ==========================
  Future<void> flaskAPI(bool identifier) async {
    if (widget.apiExtText != null || widget.inApi == true) return '';
    try {
      widget.inApi = true;
      var identifier = (_arModel) ? '/api/ar' : 'api/en';
      print(
          ' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ inside flask API $identifier');
      final url = 'http://52.165.146.57:5000$identifier';
      // final url = 'http://40.122.144.111:5000$identifier';
      // final url = 'http://23.99.224.142:5000$identifier';

      var bytesImg = await widget.chosenPic.readAsBytes();

      var response = await http.post(
        url,
        body: bytesImg,
        headers: {"Accept": "application/json"},
      );

      List<dynamic> jsonResponse = json.decode(response.body)['result'];
      setState(() {
        widget.apiExtText = jsonResponse.join(' ');
      });
    } catch (e) {
      print('error at flask');
      widget.apiExtText = 'Something Went Wrong.';
    }
    // /api/en
  }

// ======================================================================
  // // save the selected image into class variable
  // void _selectImage(File pickedImage) {
  //   // create a new picture with a diff image uri.
  //   _pictureTemplate = _mOverWritepicture(
  //     imageUrl: pickedImage,
  //   );
  // }

// ======================================================================
  void _selectPlace(double lat, double lng) {
    // save the picked location into a variable .. it's done like that as the location
    // will be a parameter passed around form another widget.
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    // create a new picture with a diff image uri.
    _pictureTemplate = _mOverWritepicture(
      location: _pickedLocation,
    );
  }

// ======================================================================

  Future<void> _mSubmitForm() async {
    // this will now Executer the 'Validator' function on every 'textFormField'.
    bool isAllDataValid = _formHandler.currentState.validate();
    // this will now Executer the 'Onsave' function on every 'textFormField'.
    if (isAllDataValid) {
      // this will show a loading indicator untill the 'http' request is handled
      setState(() {
        _isLoading = true;
      });

      _formHandler.currentState.save();
      // if the id is null .. then I came to this screen to create a new picture and so
      // I call the 'addpicture' method.
      if (_pictureTemplate.id == null) {
        try {
          // ' await ' is to handle this code as if it were 'Synchronous' .. and wait
          // for a response to then move onto the next lines.
          // _pictureTemplate = _mOverWritepicture(extractedText: widget.apiExtText);
          await Provider.of<Pictures>(context, listen: false)
              .mAddPicture(picture: _pictureTemplate);
          Navigator.of(context).pop();
        } catch (e) {
          // 'await' here to wait for the result of the 'dialog' before you move on with code.
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('An error occured!'),
                    content: Text('Something went wrong.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }
      }
      // else means that id != NULL so Iam Editing an exisitng picture and therefore
      // should only update it 's data
      else {
        try {
          // ' await ' is to handle this code as if it were 'Synchronous' .. and wait
          // for a response to then move onto the next lines.
          await Provider.of<Pictures>(context, listen: false)
              .mUpdatePicture(_pictureTemplate);

          Navigator.of(context).pop();
        } catch (e) {
          // 'await' here to wait for the result of the 'dialog' before you move on with code.
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(
                      'An error occured!',
                      textAlign: TextAlign.center,
                    ),
                    content: Text('Something went wrong.',
                        textAlign: TextAlign.center),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
// ======================================================================

  String _mValidateInput({String title}) {
    // 'title' Validation
    if (title == '') {
      return 'Title can\'t be empty.';
    }
    if (title != null) {
      if (title.isNotEmpty &&
          !title.contains(new RegExp(r'[*+,./\^`|~:;<=>?@]')) &&
          title.contains(new RegExp(r'[A-Za-z]'))) {
        // it's correct ..
        return null;
      }
      // it's false..
      else {
        return 'Title contains unvalid characters.';
      }
    }

    return null;
  }

// ======================================================================
  // to over write the 'existing' picture with the new value passed to it.
  // this will now change only the ONE value passed to it .. AND Leave the
  // rest of the parameters as is because i'll pass them with null.
  Picture _mOverWritepicture(
      {id, extractedText, imageUrl, title, isFavourite, location}) {
    // I don't update the exisiting picture cuz it's values are all final, so create a new one.
    return Picture(
      id: id != null ? id : _pictureTemplate.id,
      extractedText: extractedText != null
          ? extractedText
          : _pictureTemplate.extractedText,
      imageURI: imageUrl != null ? imageUrl : _pictureTemplate.imageURI,
      title: title != null ? title : _pictureTemplate.title,
      isFavourite:
          isFavourite != null ? isFavourite : _pictureTemplate.isFavourite,
      location: location != null ? location : _pictureTemplate.location,
    );
  }
// ======================================================================

  @override
  Widget build(BuildContext context) {
    // get the devices' dimensions
    final deviceSize = MediaQuery.of(context).size;
    // returns a 'scaffold' cuz this 'widget' is a screen.
    return Scaffold(
        appBar: AppBar(
          // change the title of the screen based on the action .. add or edit.
          title: _pictureTemplate.id == null
              ? Text('Add Picture')
              : Text('Edit Picture'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => // show the confirmation Dialogue.
                showDialog(
                    context: context,
                    // the shown dialog will be an 'alert Dialog'
                    builder: (builderContext) => AlertDialog(
                          // title of the 'alerDialog'
                          title: Text(
                            'Discard Changes?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // body of the 'alertDialog'
                          content: Text(
                            'Do you want to discard any changes you have made?',
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              // Returns a [Future] that resolves to the value (if any) that was passed
                              // to [Navigator.pop] when the dialog was closed.
                              onPressed: () =>
                                  Navigator.of(builderContext).pop(false),
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              // Returns a [Future] that resolves to the value (if any) that was passed
                              // to [Navigator.pop] when the dialog was closed.
                              onPressed: () =>
                                  Navigator.of(builderContext).pop(true),
                            )
                          ],
                          // the 'then' fuction will be executed AFTER I choose from the 'shown Dialogue'
                          // hence the name .. Future.
                        )).then((answer) {
              // If the user confirms the deletion.
              if (answer != null && answer == true) Navigator.of(context).pop();
            }),
          ),
        ),

        // 'form' is a built-in 'widget' that works behind the scenes collects the user inputs
        // and performs some validation and has a decent 'UI' to give hints to the user
        // and comment on what he has already entered.
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            // 'Key' to establish the connection between this 'widget' and the methods and code above
            key: _formHandler,
            // I could have used 'ListView' here but it gets rid of the items that are not visibile
            // and these items will be carrying some user data .. so not very helpful here ..
            // instead I use a 'column' with a 'singleChildScrollView'
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: <Widget>[
                    // Best Suited with the 'form' and is connected to it behind the scenes.
                    TextFormField(
                      // the following line checks the argument passed to this 'screen' if it's null
                      //  then I pressed on the 'New' Icon and all the form fields should be empty ..
                      // if it's NOT NULL then I pressed on the 'Edit' Button And I should fetch the existing
                      // picture's values.
                      enabled: (widget.apiExtText != null ||
                              _pictureTemplate.id != null)
                          ? true
                          : false,
                      initialValue: _pictureTemplate.title == ''
                          ? 'image1'
                          : _pictureTemplate.title,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        // the 'Hint' shown above the text filed input
                        labelText: 'Title',
                      ),
                      // the Icon shown on the keyboard when I press on this field ..
                      // 'Next' Means that it will take me to the next field and not finish.
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          // this allows me to go to the  cified 'foucsNode' when I submit this text field.
                          FocusScope.of(context).requestFocus(
                              _pictureTemplate.id == null
                                  ? null
                                  : _extractedTextFieldFocusNode),
                      validator: (val) => _mValidateInput(title: val),
                      onSaved: (newValue) =>
                          // I call the function with ONLY the parameter I wish to change .. and the rest will be null
                          _pictureTemplate = _mOverWritepicture(
                        title: newValue,
                      ),
                    ),
                    // text field for the extracted text
                    // if (widget.alreadySentAPIRequest == true && widget.apiExtText
                    (widget.apiExtText == null &&
                            _pictureTemplate.extractedText == '')
                        ? FutureBuilder(
                            future: flaskAPI(_arModel),
                            builder: (_, dataSnapShot) {
                              if (dataSnapShot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  height: 70,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 80,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Extracting',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      CircularProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      Text('Text',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor)),
                                    ],
                                  ),
                                );
                              } else {
                                // setState(() {

                                // });
                                return TextFormField(
                                  style: Theme.of(context).textTheme.headline6,
                                  initialValue: widget.apiExtText,
                                  //     ? 'READ ONLY'
                                  //     : _pictureTemplate.extractedText,
                                  keyboardType: TextInputType.multiline,
                                  // max number of 'viewable' lines of text .. the user can scroll to view more.
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    // the 'Hint' shown above the text filed input
                                    labelText: 'extractedText',
                                  ),
                                  // to mark this 'textfield' as a 'focus node'
                                  focusNode: _extractedTextFieldFocusNode,
                                  onSaved: (newValue) =>
                                      _pictureTemplate = _mOverWritepicture(
                                    extractedText: newValue,
                                  ),
                                );
                              }
                            })
                        : TextFormField(
                            style: Theme.of(context).textTheme.headline6,
                            initialValue: widget.apiExtText ??
                                _pictureTemplate.extractedText,
                            //     ? 'READ ONLY'
                            //     : _pictureTemplate.extractedText,
                            keyboardType: TextInputType.multiline,
                            // max number of 'viewable' lines of text .. the user can scroll to view more.
                            maxLines: 2,
                            decoration: InputDecoration(
                              // the 'Hint' shown above the text filed input
                              labelText: 'extractedText',
                            ),
                            // to mark this 'textfield' as a 'focus node'
                            focusNode: _extractedTextFieldFocusNode,
                            onSaved: (newValue) =>
                                _pictureTemplate = _mOverWritepicture(
                              extractedText: newValue,
                            ),
                          ),
                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            image: (widget.chosenPic == null)
                                ? null
                                : DecorationImage(
                                    image: FileImage(
                                      widget.chosenPic,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        ChoiceBox(_arModel, _enModel),
                      ],
                    ),

                    SizedBox(
                      height: deviceSize.height * 0.04,
                    ),
                    LocationInput(
                        onSelectPlace: _selectPlace,
                        initialLocation: _pictureTemplate.location),
                    SizedBox(
                      height: deviceSize.height * 0.025,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    SizedBox(
                      height: deviceSize.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Theme.of(context).primaryColor.withAlpha(170),
                          child: Text('Submit',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: (widget.apiExtText != null ||
                                  _pictureTemplate.id != null)
                              ? _mSubmitForm
                              : null,
                        ),
                        SizedBox(
                          width: 55,
                        ),
                        CancelRaisedButton(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
