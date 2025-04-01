import 'package:formz/formz.dart';

enum ZipcodeInputValidationError {
  invalid,
}

class ZipcodeInput extends FormzInput<String, ZipcodeInputValidationError> {

  /// Sets Unmodified "pure" input at start
  const ZipcodeInput.pure() : super.pure('');

  /// Password.dirty changes as data input
  const ZipcodeInput.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _zipcodeInputRegExp = RegExp(
    r'^\d{5}(-\d{4})?$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  ZipcodeInputValidationError? validator(String value) {
    return _zipcodeInputRegExp.hasMatch(value) ? null : ZipcodeInputValidationError.invalid;
  }
}