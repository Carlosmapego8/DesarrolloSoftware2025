import 'account.dart';

class User {
  final String name;
  final List<Account> accounts = [];

  User(this.name);

  void addAccount(Account account) {
    accounts.add(account);
  }
}
