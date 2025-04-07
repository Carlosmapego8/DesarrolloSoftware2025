import 'filter.dart';

class PasswordFilter extends Filter {
  @override
  String? execute(String password) {
    if (password.length < 8) return 'Contraseña demasiado corta';
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'Debe contener una mayúscula';
    if (!password.contains(RegExp(r'[0-9]')))
      return 'Debe contener un número';
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')))
      return 'Debe contener un carácter especial';
    if (RegExp(r'(.)\1{2,}').hasMatch(password))
      return 'No debe tener caracteres repetidos consecutivamente';
    return null;
  }
}
