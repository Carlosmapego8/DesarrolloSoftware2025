import 'filter.dart';

class PasswordFilter extends Filter {
  @override
  String? execute(String password) {
    if (password.length < 8) return 'Contraseña demasiado corta';
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'La contraseña debe contener una mayúscula';
    if (!password.contains(RegExp(r'[0-9]')))
      return 'La contraseña debe contener un número';
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')))
      return 'La contraseña debe contener un carácter especial';
    if (RegExp(r'(.)\1{2,}').hasMatch(password))
      return 'La contraseña no debe tener caracteres repetidos consecutivamente';
    return null;
  }
}
