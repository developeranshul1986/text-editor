import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/src/background_model.dart';
import 'package:text_editor/src/text_style_model.dart';

class ColorPalette extends StatefulWidget {
  final List<Color> colors;

  ColorPalette(this.colors);

  @override
  _ColorPaletteState createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Consumer<BackGroundModel>(
              builder: (context, backGroundModel, child) => Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  color: backGroundModel.color,
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.colorize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ...widget.colors.map((color) => _ColorPicker(color)).toList(),
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final Color color;

  _ColorPicker(this.color);

  @override
  Widget build(BuildContext context) {
    BackGroundModel backGroundModel =
        Provider.of<BackGroundModel>(context, listen: false);

    return GestureDetector(
      onTap: () => backGroundModel.backGroundColor(color),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
