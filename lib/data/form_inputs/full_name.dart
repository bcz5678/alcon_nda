import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum FullNameInputValidationError {
  invalid,
}

class FullNameInput extends FormzInput<String, FullNameInputValidationError> {

  /// Sets Unmodified "pure" input at start
  const FullNameInput.pure() : super.pure('');

  /// Password.dirty changes as data input
  const FullNameInput.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _fullNameInputRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  FullNameInputValidationError? validator(String value) {
    return _fullNameInputRegExp.hasMatch(value) ? null : FullNameInputValidationError.invalid;
  }
}