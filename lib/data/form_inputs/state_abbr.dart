import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum StateAbbrInputValidationError {
  invalid,
}

class StateAbbrInput extends FormzInput<String, StateAbbrInputValidationError> {

  /// Sets Unmodified "pure" input at start
  const StateAbbrInput.pure() : super.pure('');

  /// Password.dirty changes as data input
  const StateAbbrInput.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _stateAbbrInputRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z]).{2,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  StateAbbrInputValidationError? validator(String value) {
    return _stateAbbrInputRegExp.hasMatch(value) ? null : StateAbbrInputValidationError.invalid;
  }
}