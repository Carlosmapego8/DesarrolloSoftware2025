import '../filters/filter.dart';
import '../filters/filter_chain.dart';

class FilterManager {
  final FilterChain _chain = FilterChain();

  /// Añadir filtros
  void addFilter(Filter filter) => _chain.add(filter);

  /// Lanzar la ejecución
  String? validate(String email, String password) =>
      _chain.execute(email: email, password: password);
}
