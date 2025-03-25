import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum CityInputValidationError {
  invalid,
}

class CityInput extends FormzInput<String, CityInputValidationError> {

  /// Sets Unmodified "pure" input at start
  const CityInput.pure() : super.pure('');

  /// Password.dirty changes as data input
  const CityInput.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _cityInputRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  CityInputValidationError? validator(String value) {
    return _cityInputRegExp.hasMatch(value) ? null : CityInputValidationError.invalid;
  }
}