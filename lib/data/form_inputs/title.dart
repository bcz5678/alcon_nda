import 'package:formz/formz.dart';

enum TitleInputValidationError {
  invalid,
}

class TitleInput extends FormzInput<String, TitleInputValidationError> {

  /// Sets Unmodified "pure" input at start
  const TitleInput.pure() : super.pure('');

  /// Password.dirty changes as data input
  const TitleInput.dirty([super.value = '']) : super.dirty();

  /// FullName regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   .{5,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _titleInputRegExp = RegExp(
    r'^.{3,}$',
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  TitleInputValidationError? validator(String value) {
    return (_titleInputRegExp.hasMatch(value) || value == "") ? null : TitleInputValidationError.invalid;
  }
}