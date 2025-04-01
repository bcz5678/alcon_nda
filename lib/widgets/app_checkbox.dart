import 'package:alcon_flex_nda/app_ui/app_ui.dart' show AppColors, AppSpacing;
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  AppCheckbox({
    required this.value,
    this.onChanged,
    Color? activeColor,
    Color? fillColor,
    Color? checkColor,
    Color? focusColor,
    Color? hoverColor,
    Color? overlayColor,
    double? splashRadius,
    FocusNode? focusNode,
    OutlinedBorder? shape,
    BorderSide? side,
    super.key
  }) :  _activeColor = activeColor ?? AppColors.crystalBlue,
        _fillColor = fillColor,
        _checkColor = checkColor ?? AppColors.white,
        _focusColor = focusColor,
        _hoverColor = hoverColor,
        _overlayColor = overlayColor,
        _splashRadius = splashRadius,
        _focusNode = focusNode,
        _shape = shape,
        _side = side;


  final bool value;
  late Function(bool?)? onChanged;
  late Color? _activeColor;
  late Color? _fillColor;
  late Color? _checkColor;
  late Color? _focusColor;
  late Color? _hoverColor;
  late Color? _overlayColor;
  late double? _splashRadius;
  late FocusNode? _focusNode;
  late OutlinedBorder? _shape;
  late BorderSide? _side;


  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: _activeColor,
        fillColor: WidgetStateProperty.all(_fillColor),
        checkColor: _checkColor,
        focusColor: _focusColor,
        hoverColor: _hoverColor,
        overlayColor: WidgetStateProperty.all(_overlayColor),
        splashRadius: _splashRadius,
        focusNode: _focusNode,
        shape: _shape,
        side: _side,
    );
  }
}
