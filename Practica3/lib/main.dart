import 'package:flutter/material.dart';
import 'bankService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Service',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Bank Service home page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// En _MyHomePageState:
class _MyHomePageState extends State<MyHomePage> {
  final BankService _bank = BankService();
  final List<String> _users = ['Juan', 'María', 'Pedro'];
  String _selectedUser = 'Juan';

  @override
  void initState() {
    super.initState();
    for (var user in _users) {
      _bank.registerUser(user);
    }
  }

  void _createAccount() {
    setState(() {
      _bank.createAccount(_selectedUser);
    });
  }

  void _showTransactionDialog(String title, Function(String, double) onSubmit) {
    String? selectedAccount;
    double amount = 0;

    final userAccounts = _bank.getAccountsOfUser(_selectedUser);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: const Text("Choose Account"),
              items: userAccounts
                  .map((a) => DropdownMenuItem(value: a.number, child: Text(a.number)))
                  .toList(),
              onChanged: (val) => selectedAccount = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              onChanged: (val) => amount = double.tryParse(val) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedAccount != null && amount > 0) {
                onSubmit(selectedAccount!, amount);
                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: const Text("Accept"),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog() {
    String? fromAccount;
    String? toAccount;
    double amount = 0;

    final userAccounts = _bank.getAccountsOfUser(_selectedUser);
    final allAccounts = _bank.listAllAccounts();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Transfer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: const Text("Source Account"),
              items: userAccounts
                  .map((a) => DropdownMenuItem(value: a.number, child: Text(a.number)))
                  .toList(),
              onChanged: (val) => fromAccount = val,
            ),
            DropdownButtonFormField<String>(
              hint: const Text("Destination Account"),
              items: allAccounts
                  .map((a) => DropdownMenuItem(value: a.number, child: Text('${a.number} (${a.ownerName})')))
                  .toList(),
              onChanged: (val) => toAccount = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              onChanged: (val) => amount = double.tryParse(val) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (fromAccount != null && toAccount != null && fromAccount != toAccount && amount > 0) {
                _bank.transfer(_selectedUser, fromAccount!, toAccount!, amount);
                setState(() {});
                Navigator.of(context).pop();
              }
            },
            child: const Text("Transfer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _bank.getAccountsOfUser(_selectedUser);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - Usuario: $_selectedUser'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DropdownButton<String>(
            value: _selectedUser,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedUser = value);
              }
            },
            items: _users
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (_, index) {
          final acc = accounts[index];
          return ListTile(
            title: Text('Account ${acc.number}'),
            subtitle: Text('Balance: \$${acc.balance.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "new",
            onPressed: _createAccount,
            tooltip: 'New account',
            child: const Icon(Icons.account_balance),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "deposit",
            onPressed: () => _showTransactionDialog('Deposit', (acc, amt) => _bank.deposit(_selectedUser, acc, amt)),
            tooltip: 'Deposit',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "withdraw",
            onPressed: () => _showTransactionDialog('Withdraw', (acc, amt) => _bank.withdraw(_selectedUser, acc, amt)),
            tooltip: 'Withdraw',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "transfer",
            onPressed: _showTransferDialog,
            tooltip: 'Transfer',
            child: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
    );
  }
}