import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class GradientColorPicker extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final List<Color> colors;
  final void Function(List<Color>) onColorsChanged;
  final void Function(LinearGradient) onGradientChanged;

  const GradientColorPicker({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.colors,
    required this.onColorsChanged,
    required this.onGradientChanged,
  }) : super(key: key);

  @override
  _GradientColorPickerState createState() => _GradientColorPickerState();
}

class _GradientColorPickerState extends State<GradientColorPicker> {
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors;
  }

  void _handleColorChange(Color oldColor, Color newColor) {
    final colorIndex = _colors.indexOf(oldColor);
    setState(() {
      _colors[colorIndex] = newColor;
    });
    widget.onColorsChanged(_colors);
    widget.onGradientChanged(LinearGradient(colors: _colors));
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
                        showLabel: true,
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
