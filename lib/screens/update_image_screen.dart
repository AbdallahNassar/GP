import '../widgets/cancel_raised_button.dart';

import '../providers/pictures_provider.dart';
import 'package:provider/provider.dart';
import '../providers/picture_provider.dart';
import 'package:flutter/material.dart';

class UpdatePictureScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static const routeName = '/update-picture';

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

  // MUST be disposed of after the form terminates .. I added it to Listen to it and when
  // it is changed I reBUild the 'widget' to update the 'image preview'
  final _imageURLFieldFocusNode = FocusNode();
  // MUST be disposed of after the form terminates
  final _extractedTextFieldFocusNode = FocusNode();
  // MUST be disposed of after the form terminates
  final _imageURLFieldController = TextEditingController();

  // ========================== class methods ==========================
  @override
  void initState() {
    // MUST dispode of the listener.
    // I listen to the 'focusNode' and not the 'textFieldController' so that I update the
    // preview after the focus changes AND NOT after each keyboard strike.
    _imageURLFieldFocusNode.addListener(_mUpdateImagePreview);
    super.initState();
  }

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
        _imageURLFieldController.text = routeArguments.imageURI;
      } else
        _pictureTemplate = Picture(
            id: null,
            extractedText: '',
            imageURI: '',
            title: '',
            isFavourite: false);
      _isInitState = false;
    }
    super.didChangeDependencies();
  }

  void _mUpdateImagePreview() {
    if (!_imageURLFieldFocusNode.hasFocus) {
      if ((!_imageURLFieldController.text.startsWith('http://') &&
              !_imageURLFieldController.text.startsWith('https://')) ||
          (!_imageURLFieldController.text.endsWith('.jpeg') &&
              !_imageURLFieldController.text.endsWith('.jpg') &&
              !_imageURLFieldController.text.endsWith('.png'))) {
        // rebuild the 'widgete' to update teh preview of the image
        return;
      }
      setState(() {});
    }
  }

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

  String _mValidateInput(
      {String title, String extractedText, String imageUrl}) {
    // 'title' Validation
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

    // 'extractedText' Validation
    else if (extractedText != null) {
      if (extractedText.isEmpty) {
        return 'Please enter a extractedText.';
      }
      if (extractedText.length < 10) {
        print(extractedText);
        return 'extractedText should be at least 10 characters long.';
      }
      return null;
    }

    // 'imageUrl' Validation
    else if (imageUrl != null) {
      // if (imageUrl.isEmpty) {
      //   return 'Please enter an imageUrl.';
      // }
      // if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      //   return 'Please enter a valid URL.';
      // }
      // if (!imageUrl.endsWith('.jpeg') &&
      //     !imageUrl.endsWith('.jpg') &&
      //     !imageUrl.endsWith('.png')) {
      //   return 'Please enter a valid URL.';
      // }
      // var urlPattern =
      //     r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      // var result =
      //     new RegExp(urlPattern, caseSensitive: false).firstMatch(imageUrl);
      // if (result == null) {
      //   return 'Please enter a valid URL.';
      // }
      return null;
    }
    return null;
  }

  // to over write the 'existing' picture with the new value passed to it.
  // this will now change only the ONE value passed to it .. AND Leave the
  // rest of the parameters as is because i'll pass them with null.
  Picture _mOverWritepicture(
      {id, extractedText, imageUrl, title, isFavourite}) {
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
    );
  }

  @override
  void dispose() {
    // must be MANUALLY dispoded of to avoid memory leaks.
    _extractedTextFieldFocusNode.dispose();
    _imageURLFieldController.dispose();
    _imageURLFieldFocusNode.removeListener(_mUpdateImagePreview);
    _imageURLFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // returns a 'scaffold' cuz this 'widget' is a screen.
    return Scaffold(
        appBar: AppBar(
          // change the title of the screen based on the action .. add or edit.
          title: _pictureTemplate.id == null
              ? Text('Add Picture')
              : Text('Edit Picture'),
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
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    // Best Suited with the 'form' and is connected to it behind the scenes.
                    TextFormField(
                      // the following line checks the argument passed to this 'screen' if it's null
                      //  then I pressed on the 'New' Icon and all the form fields should be empty ..
                      // if it's NOT NULL then I pressed on the 'Edit' Button And I should fetch the existing
                      // picture's values.
                      initialValue: _pictureTemplate == null
                          ? null
                          : _pictureTemplate.title,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        // the 'Hint' shown above the text filed input
                        labelText: 'Title',
                      ),
                      // the Icon shown on the keyboard when I press on this field ..
                      // 'Next' Means that it will take me to the next field and not finish.
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          // this allows me to go to the specified 'foucsNode' when I submit this text field.
                          FocusScope.of(context)
                              .requestFocus(_extractedTextFieldFocusNode),
                      validator: (val) => _mValidateInput(title: val),
                      onSaved: (newValue) =>
                          // I call the function with ONLY the parameter I wish to change .. and the rest will be null
                          _pictureTemplate = _mOverWritepicture(
                        title: newValue,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      initialValue: _pictureTemplate == null
                          ? null
                          : _pictureTemplate.extractedText,
                      keyboardType: TextInputType.multiline,
                      // max number of 'viewable' lines of text .. the user can scroll to view more.
                      maxLines: 3,
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
                      validator: (val) => _mValidateInput(extractedText: val),

                      // No need for the Icon shown on the keyboard when I press on this field ..
                      // as it will automatically move me to the next line.
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child:
                              // previrew the image when the user types the url .. other than that show a txt.
                              _imageURLFieldController.text.isEmpty
                                  ? Text('Enter a URL',
                                      textAlign: TextAlign.center)
                                  : Image.asset(
                                      _imageURLFieldController.text,
                                      fit: BoxFit.contain,
                                    ),
                        ),
                        SizedBox(
                          width: 28,
                        ),
                        // 'Expanded' here cuz An InputDecorator, which is typically created by a TextField,
                        // cannot have an unbounded width .. and it's inside of a 'Row' so..
                        Expanded(
                          child: TextFormField(
                            // initialValue: routeArgument.imageUrl == null ? 'HE' :  routeArgument.imageUrl,
                            decoration: InputDecoration(labelText: 'ImageURL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            // we add 'controller' to get the value of the field before the value is submitted.
                            controller: _imageURLFieldController,
                            // options to show above the 'textField'
                            focusNode: _imageURLFieldFocusNode,

                            toolbarOptions: ToolbarOptions(
                                paste: true, copy: true, cut: true),
                            onSaved: (newValue) =>
                                _pictureTemplate = _mOverWritepicture(
                              imageUrl: newValue,
                            ),
                            validator: (val) => _mValidateInput(imageUrl: val),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator(),
                    SizedBox(
                      height: 40,
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
                          onPressed: _mSubmitForm,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        CancelRaisedButton()
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
