import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../screens/update_image_screen.dart';

class HomeSpeedDial extends StatelessWidget {
  final identifier;
  HomeSpeedDial(this.identifier);
  //========================== class parameters ==========================
  final _imagePicker = ImagePicker();
  // ========================== class methods ==========================

  Future<File> _mGetImage({picSource}) async {
    try {
      // pickedImage = imageFile in video
      final pickedImage = await _imagePicker.getImage(
        source: picSource,
        imageQuality: 45,
        maxHeight: 1200,
        maxWidth: 1200,
        // maxWidth: 900,
      );
      // the user canceld the camera
      if (pickedImage == null) return null;
      // everything is ok
      final File _image = File(pickedImage.path);
      // crop the image
      final cropImg = await _mCropImg(_image);
      // saving the image to the device storage.
      // get the app directory in the physical device storage
      final appDir = await sysPath.getApplicationDocumentsDirectory();
      // this will give me the image name and extension
      final fileName = path.basename(pickedImage.path);
      // copying the image into the device storage .. now the image will be a file on the
      // internal device storage.
      final savedImage = await cropImg.copy('${appDir.path}/$fileName');
      // compress img
      // Random random = new Random();
      // var i = random.nextInt(100000000);
      // final result = await FlutterImageCompress.compressAndGetFile(
      //   savedImage.absolute.path,
      //   '${appDir.path}/$fileName$i',
      //   quality: 50,
      //   minWidth: 1024,
      //   minHeight: 1024,
      // );

      // forward the image to the main screen to use it.
      // widget.onSelectImage(result);
      // final cropImg = savedImage;
      // forward the image to the main screen to use it.
      return savedImage;
    } catch (e) {
      print('Error @ picking image,$e');
      return null;
    }
  }

  Future<File> _mCropImg(savedImage) async {
    File _croppedImg = await ImageCropper.cropImage(
        sourcePath: savedImage.path,
        compressQuality: 45,
        maxHeight: 1200,
        maxWidth: 1200,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.purple,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'Crop It'));

    return _croppedImg ?? savedImage;
  }

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      elevation: 2,
      closeManually: false,
      // opacity of overlay screen,
      overlayOpacity: 0.5,
      // to animate the main flating button
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).accentColor,
      children: [
        // each one is a floating action button.. from bottom to top
        SpeedDialChild(
          onTap: () async {
            if (identifier == null) {
              return;
            }
            // call the method to get the user to provide an image through cam/gallery
            final chosenPicture =
                await _mGetImage(picSource: ImageSource.camera);
            // call the 'updatescreen' with the photo provided by user.
            if (chosenPicture != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdatePictureScreen(
                    chosenPic: chosenPicture,
                  ),
                ),
              );
            }
          },
          child: Icon(
            Icons.add_a_photo,
            size: 22,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          labelStyle: Theme.of(context).textTheme.caption,
          label: 'Camera',
        ),

        SpeedDialChild(
          onTap: () async {
            if (identifier == null) {
              return;
            }
            // call the method to get the user to provide an image through cam/gallery
            final chosenPicture =
                await _mGetImage(picSource: ImageSource.gallery);
            // call the 'updatescreen' with the photo provided by user.
            if (chosenPicture != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdatePictureScreen(
                    chosenPic: chosenPicture,
                    identifier: identifier,
                  ),
                ),
              );
            }
          },
          elevation: 2,
          child: Icon(
            Icons.add_photo_alternate,
            size: 22,
            color: Theme.of(context).primaryColor,
          ),
          labelStyle: Theme.of(context).textTheme.caption,
          label: 'Gallery',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
