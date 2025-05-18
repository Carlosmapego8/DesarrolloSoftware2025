import 'account.dart';
import 'transaction.dart';
import 'user.dart';

class BankService {
  final Map<String, Account> _accounts = {};
  final Map<String, List<String>> _userAccounts = {}; // ownerName -> list of account numbers
  final Map<String, Account> _transactions = {};
  int _transactionCounter = 0;
  int _accountCounter = 1000;

  void registerUser(String name) {
    _userAccounts.putIfAbsent(name, () => []);
  }

  String _generateTransactionId(Account account) {
    String transaction_id = 'TX${_transactionCounter++}';
    _transactions[transaction_id] = account;
    return transaction_id;
  }

  String _generateAccountNumber() => 'AC${_accountCounter++}';

  Account createAccount(String ownerName) {
    final number = _generateAccountNumber();
    final account = Account(number, ownerName);
    _accounts[number] = account;
    _userAccounts[ownerName]?.add(number);
    return account;
  }

  List<Account> getAccountsOfUser(String name) {
    final accountNumbers = _userAccounts[name] ?? [];
    return accountNumbers.map((n) => _accounts[n]!).toList();
  }

  Account? getAccount(String number) => _accounts[number];

  void deposit(String ownerName, String accountNumber, double amount) {
    final account = _getOwnedAccountOrThrow(ownerName, accountNumber);
    final tx = DepositTransaction(_generateTransactionId(account), amount);
    tx.apply(account);
  }

  void withdraw(String ownerName, String accountNumber, double amount) {
    final account = _getOwnedAccountOrThrow(ownerName, accountNumber);
    final tx = WithdrawalTransaction(_generateTransactionId(account), amount);
    tx.apply(account);
  }

  void transfer(String ownerName, String fromNumber, String toNumber, double amount) {
    final from = _getOwnedAccountOrThrow(ownerName, fromNumber);
    final to = _accounts[toNumber];
    if (to == null) throw ArgumentError('No existe la cuenta destino: $toNumber');

    final tx = TransferTransaction(_generateTransactionId(from), amount, to);
    tx.apply(from);
  }

  double getBalance(String accountNumber) =>
      _getAccountOrThrow(accountNumber).balance;

  List<Account> listAllAccounts() => _accounts.values.toList();

  Account _getAccountOrThrow(String number) {
    final account = _accounts[number];
    if (account == null) throw ArgumentError('No existe la cuenta: $number');
    return account;
  }

  Account _getOwnedAccountOrThrow(String ownerName, String number) {
    final account = _getAccountOrThrow(number);
    if (account.ownerName != ownerName) {
      throw StateError('La cuenta no pertenece a $ownerName');
    }
    return account;
  }
}