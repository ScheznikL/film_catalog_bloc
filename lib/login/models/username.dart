import 'package:formz/formz.dart';

enum EmailValidationError { empty }

class Username extends FormzInput<String, EmailValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    return null;
  }
}
