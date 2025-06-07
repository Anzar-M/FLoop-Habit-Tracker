import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorChanged;
  final double size;

  const ColorPickerWidget({
    Key? key,
    required this.initialColor,
    required this.onColorChanged,
    this.size = 60,
  }) : super(key: key);

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return ColorIndicator(
      width: widget.size,
      height: widget.size,
      color: _selectedColor,
      onSelect: () async {
        final newColor = await showColorPickerDialog(
          context,
          _selectedColor,
          pickersEnabled: {ColorPickerType.wheel: true},
        );
        setState(() => _selectedColor = newColor);
        widget.onColorChanged(newColor);
      },
    );
  }
}