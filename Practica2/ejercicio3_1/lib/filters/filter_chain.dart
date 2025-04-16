import 'filter.dart';
import 'email_filter.dart';
import 'password_filter.dart';
import 'email_exists_filter.dart';

class FilterChain {
  final List<Filter> _filters = [];

  /// Añadir filtros en el orden de ejecución deseado
  void add(Filter filter) => _filters.add(filter);

  /// Recorre la cadena; si un filtro devuelve mensaje de error, corta la ejecución
  String? execute({
    required String email,
    required String password,
  }) {
    for (final filter in _filters) {
      String? result;
      if (filter is EmailFilter || filter is EmailExistsFilter) {
        result = filter.execute(email);
      } else if (filter is PasswordFilter) {
        result = filter.execute(password);
      }
      if (result != null) return result;
    }
    return null;
  }
}
