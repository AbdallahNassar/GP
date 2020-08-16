import 'package:flutter/material.dart';

class ChoiceBox extends StatefulWidget {
  bool _arModel;
  bool _enModel;
  ChoiceBox(this._arModel, this._enModel);
  @override
  _ChoiceBoxState createState() => _ChoiceBoxState();
}

class _ChoiceBoxState extends State<ChoiceBox> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChoiceChip(
            label: Text('Arabic'),
            selected: widget._arModel,
            selectedColor: Colors.green,
            onSelected: (val) {
              if (widget._arModel == false) {
                setState(() {
                  widget._enModel = !widget._enModel;
                  widget._arModel = !widget._arModel;
                });
              }
            },
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          ChoiceChip(
            label: Text('English'),
            selected: widget._enModel,
            disabledColor: Colors.grey,
            selectedColor: Colors.green,
            onSelected: (_) {
              // to not change it if it's already selected
              if (widget._enModel == false) {
                setState(() {
                  widget._arModel = !widget._arModel;
                  widget._enModel = !widget._enModel;
                });
              }
            },
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
