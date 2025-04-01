import 'package:alcon_flex_nda/app_ui/app_ui.dart' show AppColors, AppSpacing;
import 'package:flutter/material.dart';
import 'widgets.dart' show AppCheckbox;

class AppExperiencesCheckbox extends StatelessWidget {
  const AppExperiencesCheckbox({
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.shape,
    this.side,
    super.key
  });

  final bool value;
  final Function(bool?) onChanged;
  final Color? activeColor;
  final Color? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final OutlinedBorder? shape;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return AppCheckbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      focusNode: focusNode,
      shape: shape,
      side: side,
    );
  }
}
