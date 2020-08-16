import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// flare widgets must be statful, duh!
class TestScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static String routeName = '/test';
  var text = '';
  // ======================================================================

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // ========================== class parameters ==========================
  void flaskAPI() async {
    print('in trial');
    final url = 'http://23.99.224.142:5000/api/en';

    var imgFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    var bytesImg = await imgFile.readAsBytes();

    print('======================= run time type = ${bytesImg.runtimeType}');
    var response = await http.post(
      url,
      body: bytesImg,
      headers: {"Accept": "application/json"},
    );
    var jsonResponse = json.decode(response.body);
    print(jsonResponse['result']);
  }

  void trial() {
    var x = 'الحمدلله';
    setState(() {
      widget.text = x;
    });
    print(x); // String body = utf8.decode(x);
    // print(body);
  }

  void brain() {}
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.tab),
              onPressed: trial,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
