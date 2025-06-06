import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_ui/app_ui.dart';


/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    super.key,
    this.autoFillHints,
    this.controller,
    this.initialValue,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.textCapitalization,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.padding,
    this.obscureText = false,
  });

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  final String? initialValue;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// Define the text-capitalization for input
  final TextCapitalization? textCapitalization;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  /// Optional padding set
  final Padding? padding;

  /// Boolean to obscure/hide password text
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: TextFormField(
            key: key,
            controller: controller,
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            autocorrect: autocorrect,
            readOnly: readOnly,
            obscureText: obscureText,
            autofillHints: autoFillHints,
            cursorColor: AppColors.black,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
            textCapitalization: textCapitalization ?? TextCapitalization.sentences,
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const AppTheme().themeData.inputDecorationTheme.hintStyle!.copyWith(fontStyle: FontStyle.italic),
              errorText: errorText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              border: const AppTheme().themeData.inputDecorationTheme.border,
              enabledBorder: const AppTheme().themeData.inputDecorationTheme.enabledBorder,
              focusedBorder: const AppTheme().themeData.inputDecorationTheme.focusedBorder,
              disabledBorder: const AppTheme().themeData.inputDecorationTheme.disabledBorder,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
            ),
            onChanged: onChanged,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
