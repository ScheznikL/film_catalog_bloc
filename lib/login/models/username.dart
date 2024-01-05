import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid}

class Username extends FormzInput<String, EmailValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[\w.!#$%&’*+/=?^_`{|}~-]+@[\w-]+(?:\.[\w-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if(!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}
