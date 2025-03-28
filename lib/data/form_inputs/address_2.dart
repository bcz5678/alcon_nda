import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum Address2InputValidationError {
  invalid,
}

class Address2Input extends FormzInput<String, Address2InputValidationError> {

  /// Sets Unmodified "pure" input at start
  const Address2Input.pure() : super.pure('');

  /// Password.dirty changes as data input
  const Address2Input.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _address2InputRegExp = RegExp(
    r'^.{1,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  Address2InputValidationError? validator(String value) {
    return (_address2InputRegExp.hasMatch(value) || value == "") ? null : Address2InputValidationError.invalid;
  }
}