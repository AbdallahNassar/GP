import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import '../helpers/language_list.dart';

// flare widgets must be statful, duh!
class TestScreen extends StatefulWidget {
  // ========================== class parameters ==========================
  static String routeName = '/test';
  var text = '';
  var _selected;

  // ======================================================================

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // ========================== class parameters ==========================
  List<Map<String, String>> _langMap = [
    {'lang': 'Afrikaans', 'code': 'af'},
    {'lang': 'Albanian', 'code': 'sq'},
    {'lang': 'Amharic', 'code': 'am'},
    {'lang': 'Arabic', 'code': 'ar'},
    {'lang': 'Armenian', 'code': 'hy'},
    {'lang': 'Azerbaijani', 'code': 'az'},
    {'lang': 'Basque', 'code': 'eu'},
    {'lang': 'Belarusian', 'code': 'be'},
    {'lang': 'Bengali', 'code': 'bn'},
    {'lang': 'Bosnian', 'code': 'bs'},
    {'lang': 'Bulgarian', 'code': 'bg'},
    {'lang': 'Catalan', 'code': 'ca'},
    {'lang': 'Cebuano', 'code': 'ceb'},
    {'lang': 'Chinese (Simplified)', 'code': 'zh'},
    {'lang': 'Chinese (Traditional)', 'code': 'zh-TW'},
    {'lang': 'Corsican', 'code': 'co'},
    {'lang': 'Croatian', 'code': 'hr'},
    {'lang': 'Czech', 'code': 'cs'},
    {'lang': 'Danish', 'code': 'da'},
    {'lang': 'Dutch', 'code': 'nl'},
    {'lang': 'English', 'code': 'en'},
    {'lang': 'Esperanto', 'code': 'eo'},
    {'lang': 'Estonian', 'code': 'et'},
    {'lang': 'Finnish', 'code': 'fi'},
    {'lang': 'French', 'code': 'fr'},
    {'lang': 'Frisian', 'code': 'fy'},
    {'lang': 'Galician', 'code': 'gl'},
    {'lang': 'Georgian', 'code': 'ka'},
    {'lang': 'German', 'code': 'de'},
    {'lang': 'Greek', 'code': 'el'},
    {'lang': 'Gujarati', 'code': 'gu'},
    {'lang': 'Haitian Creole', 'code': 'ht'},
    {'lang': 'Hausa', 'code': 'ha'},
    {'lang': 'Hawaiian', 'code': 'haw'},
    {'lang': 'Hebrew', 'code': 'he'},
    {'lang': 'Hindi', 'code': 'hi'},
    {'lang': 'Hmong', 'code': 'hmn'},
    {'lang': 'Hungarian', 'code': 'hu'},
    {'lang': 'Icelandic', 'code': 'is'},
    {'lang': 'Igbo', 'code': 'ig'},
    {'lang': 'Indonesian', 'code': 'id'},
    {'lang': 'Irish', 'code': 'ga'},
    {'lang': 'Italian', 'code': 'it'},
    {'lang': 'Japanese', 'code': 'ja'},
    {'lang': 'Javanese', 'code': 'jv'},
    {'lang': 'Kannada', 'code': 'kn'},
    {'lang': 'Kazakh', 'code': 'kk'},
    {'lang': 'Khmer', 'code': 'km'},
    {'lang': 'Kinyarwanda', 'code': 'rw'},
    {'lang': 'Korean', 'code': 'ko'},
    {'lang': 'Kurdish', 'code': 'ku'},
    {'lang': 'Kyrgyz', 'code': 'ky'},
    {'lang': 'Lao', 'code': 'lo'},
    {'lang': 'Latin', 'code': 'la'},
    {'lang': 'Latvian', 'code': 'lv'},
    {'lang': 'Lithuanian', 'code': 'lt'},
    {'lang': 'Luxembourgish', 'code': 'lb'},
    {'lang': 'Macedonian', 'code': 'mk'},
    {'lang': 'Malagasy', 'code': 'mg'},
    {'lang': 'Malay', 'code': 'ms'},
    {'lang': 'Malayalam', 'code': 'ml'},
    {'lang': 'Maltese', 'code': 'mt'},
    {'lang': 'Maori', 'code': 'mi'},
    {'lang': 'Marathi', 'code': 'mr'},
    {'lang': 'Mongolian', 'code': 'mn'},
    {'lang': 'Myanmar (Burmese)', 'code': 'my'},
    {'lang': 'Nepali', 'code': 'ne'},
    {'lang': 'Norwegian', 'code': 'no'},
    {'lang': 'Nyanja (Chichewa)', 'code': 'ny'},
    {'lang': 'Odia (Oriya)', 'code': 'or'},
    {'lang': 'Pashto', 'code': 'ps'},
    {'lang': 'Persian', 'code': 'fa'},
    {'lang': 'Polish', 'code': 'pl'},
    {'lang': 'Portuguese (Portugal ,Brazil)', 'code': 'pt'},
    {'lang': 'Punjabi', 'code': 'pa'},
    {'lang': 'Romanian', 'code': 'ro'},
    {'lang': 'Russian', 'code': 'ru'},
    {'lang': 'Samoan', 'code': 'sm'},
    {'lang': 'Scots Gaelic', 'code': 'gd'},
    {'lang': 'Serbian', 'code': 'sr'},
    {'lang': 'Sesotho', 'code': 'st'},
    {'lang': 'Shona', 'code': 'sn'},
    {'lang': 'Sindhi', 'code': 'sd'},
    {'lang': 'Sinhala (Sinhalese)', 'code': 'si'},
    {'lang': 'Slovak', 'code': 'sk'},
    {'lang': 'Slovenian', 'code': 'sl'},
    {'lang': 'Somali', 'code': 'so'},
    {'lang': 'Spanish', 'code': 'es'},
    {'lang': 'Sundanese', 'code': 'su'},
    {'lang': 'Swahili', 'code': 'sw'},
    {'lang': 'Swedish', 'code': 'sv'},
    {'lang': 'Tagalog (Filipino)', 'code': 'tl'},
    {'lang': 'Tajik', 'code': 'tg'},
    {'lang': 'Tamil', 'code': 'ta'},
    {'lang': 'Tatar', 'code': 'tt'},
    {'lang': 'Telugu', 'code': 'te'},
    {'lang': 'Thai', 'code': 'th'},
    {'lang': 'Turkish', 'code': 'tr'},
    {'lang': 'Turkmen', 'code': 'tk'},
    {'lang': 'Ukrainian', 'code': 'uk'},
    {'lang': 'Urdu', 'code': 'ur'},
    {'lang': 'Uyghur', 'code': 'ug'},
    {'lang': 'Uzbek', 'code': 'uz'},
    {'lang': 'Vietnamese', 'code': 'vi'},
    {'lang': 'Welsh', 'code': 'cy'},
    {'lang': 'Xhosa', 'code': 'xh'},
    {'lang': 'Yiddish', 'code': 'yi'},
    {'lang': 'Yoruba', 'code': 'yo'},
    {'lang': 'Zulu', 'code': 'zu'},
  ];
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

  void trial() async {
    GoogleTranslator translator = GoogleTranslator();

    var x = 'الحمدلله';
    var y = await translator.translate(x, to: 'en');

    setState(() {
      widget.text = y.toString();
    });
  }

  void brain() {}
  // ======================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        isDense: true,
                        hint: widget._selected == null
                            ? Text("Select Language")
                            : Text(_langMap.firstWhere((element) =>
                                element['code'] == widget._selected)['lang']),
                        value: widget._selected,
                        onChanged: (String newValue) {
                          setState(() {
                            widget._selected = newValue;
                          });

                          print(widget._selected);
                        },
                        items: _langMap.map((map) {
                          return DropdownMenuItem<String>(
                            value: map['code'],
                            // value: _mySelection,
                            child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(map['lang'])),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           IconButton(
  //             icon: Icon(Icons.tab),
  //             onPressed: trial,
  //           ),
  //           Text(
  //             widget.text,
  //             style: TextStyle(
  //               color: Colors.black,
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
