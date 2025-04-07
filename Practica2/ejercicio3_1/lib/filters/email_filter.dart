import 'filter.dart';

class EmailFilter extends Filter {
  @override
  String? execute(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
    if (!emailRegex.hasMatch(email)) {
      return 'Correo inválido';
    }
    return null;
  }
}
