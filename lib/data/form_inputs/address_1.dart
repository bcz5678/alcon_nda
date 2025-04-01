import 'package:formz/formz.dart';

enum Address1InputValidationError {
  invalid,
}

class Address1Input extends FormzInput<String, Address1InputValidationError> {

  /// Sets Unmodified "pure" input at start
  const Address1Input.pure() : super.pure('');

  /// Password.dirty changes as data input
  const Address1Input.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _address1InputRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  Address1InputValidationError? validator(String value) {
    return _address1InputRegExp.hasMatch(value) ? null : Address1InputValidationError.invalid;
  }
}