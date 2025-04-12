import 'package:ejercicio3_1/filters/email_exists_filter.dart';

import '../filters/filter.dart';
import '../filters/email_filter.dart';
import '../filters/password_filter.dart';

class FilterManager {
  final List<Filter> filters = [];

  void addFilter(Filter filter) {
    filters.add(filter);
  }

  String? executeFilters(String email, String password) {
    for (var filter in filters) {
      if (filter is EmailFilter) {
        final result = filter.execute(email);
        if (result != null) return result;
      } else if (filter is PasswordFilter) {
        final result = filter.execute(password);
        if (result != null) return result;
      } else if (filter is EmailExistsFilter) {
        final result = filter.execute(email);
        if (result != null) return result;
      }
    }
    return null;
  }
}
