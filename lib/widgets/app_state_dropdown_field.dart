import 'package:alcon_flex_nda/app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:alcon_flex_nda/data/data/data.dart';

/// {@template app_email_text_field}
/// An email text field component.
/// {@endtemplate}
class AppStateAbbrDropdownField extends StatefulWidget {
  /// {@macro app_email_text_field}
  const AppStateAbbrDropdownField({
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
  final ValueChanged<dynamic>? onChanged;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool? readOnly;

  @override
  State<AppStateAbbrDropdownField> createState() => _AppStateAbbrDropdownFieldState();
}

class _AppStateAbbrDropdownFieldState extends State<AppStateAbbrDropdownField> {
  late List<DropdownMenuItem<dynamic>> _statesList;



  @override
  void initState() {
    _statesList = buildStateList(statesAbbrArray);
    super.initState();
  }


  List<DropdownMenuItem<dynamic>> buildStateList(List<Map<String, dynamic>> entryList) {
    List<DropdownMenuItem> returnList = [];
    for(var index = 0; index < entryList.length; index++) {
      returnList.add(
          DropdownMenuItem(
            value: entryList[index]["name"],
            child: Text(
                entryList[index]["name"]
            ),
          )
      );
    }
    return returnList;
  }


  @override
  Widget build(BuildContext context) {
    return AppDropdownField(
      items: _statesList,
      hintText: widget.hintText,
      errorText: widget.errorText,
      prefix: const Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        child: Icon(
          Icons.map_outlined,
          color: AppColors.mediumEmphasisSurface,
          size: 24,
        ),
      ),
      onChanged: widget.onChanged,
      suffix: widget.suffix,
    );
  }
}



