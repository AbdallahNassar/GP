import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

class ImageInput extends StatefulWidget {
  // ========================== class parameters ==========================
  final Function onSelectImage;
  final File initialImage;
  // ========================== class constructor ==========================
  const ImageInput({
    this.onSelectImage,
    this.initialImage,
  });
  // ======================================================================
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  // ========================== class parameters ==========================
  File _image;
  final _imagePicker = ImagePicker();
  // ========================== class methods ==========================
  Future<void> _mGetImage() async {
    try {
      // pickedImage = imageFile in video
      final pickedImage = await _imagePicker.getImage(
        source: ImageSource.camera,
        // maxWidth: 900,
      );
      // the user canceld the camera
      if (pickedImage == null) return;
      setState(() {
        _image = File(pickedImage.path);
      });
      // saving the image to the device storage.
      // get the app directory in the physical device storage
      final appDir = await sysPath.getApplicationDocumentsDirectory();
      // this will give me the image name and extension
      final fileName = path.basename(pickedImage.path);
      // copying the image into the device storage .. now the image will be a file on the
      // internal device storage.
      final savedImage = await _image.copy('${appDir.path}/$fileName');
      // forward the image to the main screen to use it.
      // crop the image
      final cropImg = await _mCropImg(savedImage);
      // forward the image to the main screen to use it.
      widget.onSelectImage(cropImg);
    } catch (e) {
      print('Error @ picking image,$e');
      return null;
    }
  }

  Future<File> _mCropImg(savedImage) async {
    File _croppedImg = await ImageCropper.cropImage(
      sourcePath: savedImage.path,
      androidUiSettings: AndroidUiSettings(
          statusBarColor: Theme.of(context).primaryColor,
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
          toolbarTitle: 'Crop It'),
    );

    return _croppedImg ?? savedImage;
  }

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey,
            ),
            image: (_image == null && widget.initialImage == null)
                ? null
                : DecorationImage(
                    image: FileImage(
                      _image ?? widget.initialImage,
                    ),
                  ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            label: Text('Take Different Picture'),
            icon: Icon(Icons.add_a_photo),
            onPressed: _mGetImage,
          ),
        ),
      ],
    );
  }
}
