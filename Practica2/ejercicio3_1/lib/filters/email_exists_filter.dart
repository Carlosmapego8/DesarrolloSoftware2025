import 'filter.dart';
import '../data/mock_user_database.dart';

class EmailExistsFilter extends Filter {
  @override
  String? execute(String email) {
    if (!MockUserDatabase.emailExists(email)) {
      return 'Este correo no ha sido registrado.';
    }
    return null;
  }
}
