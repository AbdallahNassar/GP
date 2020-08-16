import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import '../widgets/picture_speed_dial.dart';
import '../providers/picture_provider.dart';
import '../providers/pictures_provider.dart';

class PictureDetails extends StatefulWidget {
  // ========================== class parameters ==========================
  static const routeName = '/picture-details-screen';
  static const emptyLoc = '';

  var _selected;
  var translationText;

  @override
  _PictureDetailsState createState() => _PictureDetailsState();
}

class _PictureDetailsState extends State<PictureDetails> {
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
    {'lang': 'Chinese (Simplified)', 'code': 'zh-CN'},
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

  Future<void> goTranslate(text, lang) async {
    try {
      print(text);
      print(lang);
      final GoogleTranslator translator = GoogleTranslator();

      var y = await translator.translate(
        text.toLowerCase(),
        to: lang.toString(),
      );

      setState(() {
        widget.translationText = y.toString();
      });
    } catch (e) {
      print('error @ translation : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 'modalRoute' to extract the Arguments passed via the routes
    final routeArgument = ModalRoute.of(context).settings.arguments as String;

    final picturesProvider = Provider.of<Pictures>(context, listen: false);
    // now I search the 'list' in the 'provider' for the element with the ID sent to my via the route
    // to dynamically retrieve All the picture details instead of passing it around.
    final Picture pictureData = picturesProvider.mFindByID(routeArgument);

    print('picture TEXTs = ${pictureData.extractedText}');
    // to avoid deletions[w/o restoration] error.
    if (pictureData == null)
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    final index = picturesProvider.pictureList.indexOf(pictureData);
    if (index == -1)
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );

    // 'safearea' to respect any notches or shoit
    // creating a provider of 'picture' to access it and change it's fav
    return ChangeNotifierProvider.value(
      value: picturesProvider.pictureList[index], //change builder to create
      child: Consumer<Picture>(
        builder: (context, provider, child) => Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              // A list of 'widgets' to scroll through
              slivers: <Widget>[
                SliverAppBar(
                  // centerTitle: true,
                  elevation: 4.0,
                  // the height it will have if it's NOT the 'appbar'
                  expandedHeight: 300,
                  // should the appbar remail visibile after you scroll down ?
                  pinned: true,
                  // our new appbar details
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    title: Container(
                      height: 90,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(
                        right: 9.0,
                        left: 9.0,
                        bottom: 2.0,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: pictureData.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontFamily: 'Lobster',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 23,
                                  ),
                            ),
                            TextSpan(
                              text:
                                  '\n${pictureData.location.address == null ? PictureDetails.emptyLoc : pictureData.location.address}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    // what to see if the 'appbar' is expanded
                    background: Hero(
                      // 'tag' to identify the 'widget' that I wish to animate .. should be unique
                      tag: pictureData.id,
                      child: Image.file(
                        // file to show it .. I use file because of 'imgacropper'
                        File(pictureData.imageURI),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // the rest of the stuff in the screen
                SliverList(
                  // 'delegate' to tell flutter how to render the content of the list
                  // 'SliverChildListDelegate' takes a list of items that will not be in the sliver
                  delegate: SliverChildListDelegate(
                    [
                      // SizedBox(
                      //   height: 30,
                      // ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.black54,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          pictureData.extractedText,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      if (widget.translationText != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.black54,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            widget.translationText,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        // width: MediaQuery.of(context).size.width * 0.1,

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
                                        ? Text("Select Translation Language")
                                        : Text(_langMap.firstWhere((element) =>
                                            element['code'] ==
                                            widget._selected)['lang']),
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

                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: RaisedButton(
                          onPressed: () async => await goTranslate(
                              pictureData.extractedText, widget._selected),
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Theme.of(context).accentColor,
                          child: Text(
                            'Translate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // 'speed dial' to have an action button that opens other action buttons.
          floatingActionButton: PictureSpeedDial(pictureData: pictureData),
        ),
      ),
    );
  }
}
