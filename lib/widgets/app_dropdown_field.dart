import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_ui/app_ui.dart';

/// {@template app_text_field}
/// A dropdown field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppDropdownField extends StatefulWidget {
  /// {@macro app_text_field}
  const AppDropdownField({
    super.key,
    this.items,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.padding,
  });


  /// List of DropdownMenuItem<T>
  final List<DropdownMenuItem<dynamic>>? items;

  /// Prefills value if present in Bloc State.
  final String? initialValue;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<dynamic>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<dynamic>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  /// Optional padding set
  final Padding? padding;

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  /// Value selected on the
  late String? _selectedStateAbbr;

  @override
  void initState() {
    super.initState();
    _selectedStateAbbr = null;
    if(widget.initialValue != null) {
      _selectedStateAbbr = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: DropdownButtonFormField(
            items: widget.items,
            value: _selectedStateAbbr,
            icon: Icon(
              Icons.arrow_drop_down_outlined,
              color: AppColors.mediumEmphasisSurface,
              size: 24,
            ),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const AppTheme().themeData.inputDecorationTheme.hintStyle!.copyWith(fontStyle: FontStyle.italic),
              errorText: widget.errorText,
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
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
            onChanged: widget.onChanged,
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}
