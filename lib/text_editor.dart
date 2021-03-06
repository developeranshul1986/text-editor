library text_editor;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/src/background_model.dart';
import 'package:text_editor/src/font_option_model.dart';
import 'package:text_editor/src/text_style_model.dart';
import 'package:text_editor/src/widget/color_palette.dart';
import 'package:text_editor/src/widget/font_family.dart';
import 'package:text_editor/src/widget/font_size.dart';
import 'package:text_editor/src/widget/font_option_switch.dart';
import 'package:text_editor/src/widget/text_alignment.dart';

/// Instagram like text editor
/// A flutter widget that edit text style and text alignment
///
/// You can pass your text style to the widget
/// and then get the edited text style
class TextEditor extends StatefulWidget {
  /// After edit process completed, [onEditCompleted] callback will be called.
  final void Function(TextStyle, TextAlign, String, Color) onEditCompleted;

  /// [onTextAlignChanged] will be called after [textAlingment] prop has changed
  final ValueChanged<TextAlign> onTextAlignChanged;

  /// [onTextStyleChanged] will be called after [textStyle] prop has changed
  final ValueChanged<TextStyle> onTextStyleChanged;

  /// [onTextChanged] will be called after [text] prop has changed
  final ValueChanged<String> onTextChanged;

  /// The text alignment
  final TextAlign textAlingment;

  /// The text style
  final TextStyle textStyle;

  /// Widget's background color
  final Color backgroundColor;

  /// Editor's font families
  final List<String> fonts;

  /// Editor's palette colors
  final List<Color> paletteColors;

  /// Editor's default text
  final String text;

  /// Decoration to customize the editor
  final EditorDecoration decoration;

  /// Create a [TextEditor] widget
  ///
  /// [fonts] list of font families that you want to use in editor.
  ///
  /// After edit process completed, [onEditCompleted] callback will be called
  /// with new [textStyle], [textAlingment] and [text] value
  TextEditor({
    @required this.fonts,
    @required this.onEditCompleted,
    this.paletteColors,
    this.backgroundColor,
    this.text = '',
    this.textStyle,
    this.textAlingment,
    this.onTextAlignChanged,
    this.onTextStyleChanged,
    this.onTextChanged,
    this.decoration,
  });

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextStyleModel _textStyleModel;
  FontOptionModel _fontOptionModel;
  BackGroundModel _backGroundModel;
  Widget _doneButton;

  @override
  void initState() {
    _textStyleModel = TextStyleModel(
      widget.text,
      widget.textStyle == null ? TextStyle() : widget.textStyle,
      widget.textAlingment == null ? TextAlign.center : widget.textAlingment,
    );
    
    _fontOptionModel = FontOptionModel(
      _textStyleModel,
      widget.fonts,
      _backGroundModel,
      colors: widget.paletteColors,
    );
    _backGroundModel = BackGroundModel(widget.backgroundColor);
    // Initialize decorator
    _doneButton = widget.decoration?.doneButton == null
        ? Text('Done', style: TextStyle(color: Colors.white))
        : widget.decoration.doneButton;

    super.initState();
  }

  void _editCompleteHandler() {
    widget.onEditCompleted(
      _textStyleModel.textStyle,
      _textStyleModel.textAlign,
      _textStyleModel.text,
      _backGroundModel.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _textStyleModel),
        ChangeNotifierProvider(create: (context) => _fontOptionModel),
        ChangeNotifierProvider(create: (context) => _backGroundModel),
      ],
      child: 
      Consumer<BackGroundModel>(builder: (context, _backGroundModel, child) {
        return Container(
          padding: EdgeInsets.only(right: 10, left: 10),
          color: _backGroundModel.color,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextAlignment(
                          left: widget.decoration?.alignment?.left,
                          center: widget.decoration?.alignment?.center,
                          right: widget.decoration?.alignment?.right,
                        ),
                        SizedBox(width: 20),
                        FontOptionSwitch(
                          fontFamilySwitch: widget.decoration?.fontFamily,
                          colorPaletteSwitch: widget.decoration?.colorPalette,
                        ),
                        // TODO: Add text background color
                        // SizedBox(width: 20),
                        // TextBackgroundColor(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _editCompleteHandler,
                        child: _doneButton,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
//                   FontSize(),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Consumer<TextStyleModel>(
                            builder: (context, textStyleModel, child) {
                              return TextField(
                                controller: TextEditingController()
                                  ..text = textStyleModel.text,
                                onChanged: (value) =>
                                    textStyleModel.text = value,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: textStyleModel.textStyle,
                                textAlign: textStyleModel.textAlign,
                                autofocus: true,
                                cursorColor: Colors.white,
                                decoration: null,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Consumer<FontOptionModel>(
                  builder: (context, model, child) =>
                      model.status == FontOptionStatus.fontFamily
                          ? FontFamily(model.fonts)
                          : ColorPalette(model.colors),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Decoration to customize text alignment widgets' design.
///
/// Pass your custom widget to `left`, `right` and `center` to customize their design
class AlignmentDecoration {
  /// Left alignment widget
  final Widget left;

  /// Center alignment widget
  final Widget center;

  /// Right alignment widget
  final Widget right;

  AlignmentDecoration({this.left, this.center, this.right});
}

/// Decoration to customize the editor
///
/// By using this class, you can customize the text editor's design
class EditorDecoration {
  /// Done button widget
  final Widget doneButton;
  final AlignmentDecoration alignment;

  /// Font family switch widget
  final Widget fontFamily;

  /// Color palette switch widget
  final Widget colorPalette;

  EditorDecoration({
    this.doneButton,
    this.alignment,
    this.fontFamily,
    this.colorPalette,
  });
}
