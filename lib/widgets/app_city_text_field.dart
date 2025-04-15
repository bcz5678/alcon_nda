import 'package:flutter/material.dart';
import 'widgets.dart' show AppTextField;
import 'package:app_ui/app_ui.dart';

/// {@template app_email_text_field}
/// An email text field component.
/// {@endtemplate}
class AppCityTextField extends StatelessWidget {
  /// {@macro app_email_text_field}
  const AppCityTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.suffix,
    this.readOnly,
    this.onChanged,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that displays validation error message.
  final String? errorText;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      errorText: errorText,
      keyboardType: TextInputType.name,
      autoFillHints: const [AutofillHints.name],
      autocorrect: false,
      prefix: const Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        child: Icon(
          Icons.location_city_outlined,
          color: AppColors.mediumEmphasisSurface,
          size: 24,
        ),
      ),
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      suffix: suffix,
    );
  }
}
