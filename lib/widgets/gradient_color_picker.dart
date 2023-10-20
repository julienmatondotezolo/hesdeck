import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class GradientColorPicker extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final List<Color> colors;
  final void Function(List<Color>, AlignmentGeometry, AlignmentGeometry)
      onColorsChanged;
  final void Function(LinearGradient) onGradientChanged;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientColorPicker({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.colors,
    required this.onColorsChanged,
    required this.onGradientChanged,
    required this.begin,
    required this.end,
  }) : super(key: key);

  @override
  GradientColorPickerState createState() => GradientColorPickerState();
}

class GradientColorPickerState extends State<GradientColorPicker> {
  late List<Color> _colors;
  late AlignmentGeometry _begin;
  late AlignmentGeometry _end;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors;
    _begin = widget.begin;
    _end = widget.end;
  }

  void _handleColorChange(Color oldColor, Color newColor) {
    final List<Color> updatedColors =
        List.from(_colors); // Create a new list based on _colors
    final colorIndex = updatedColors.indexOf(oldColor);
    updatedColors[colorIndex] = newColor; // Modify the new list
    setState(() {
      _colors = updatedColors; // Assign the updated list to _colors
    });
    widget.onColorsChanged(_colors, _begin, _end);
    widget.onGradientChanged(LinearGradient(
      colors: _colors,
      begin: _begin,
      end: _end,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final Color? newColor = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Select Color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _colors[index],
                        onColorChanged: (newColor) {
                          _handleColorChange(_colors[index], newColor);
                        },
                        labelTypes: const [], // Use an empty list to disable the label
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(_colors[index]);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  );
                },
              );
              if (newColor != null) {
                _handleColorChange(_colors[index], newColor);
              }
            },
            child: Container(
              width: widget.height,
              height: widget.height,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: _colors[index],
                borderRadius: widget.borderRadius,
              ),
            ),
          );
        },
      ),
    );
  }
}
