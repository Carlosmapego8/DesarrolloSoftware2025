import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'strategy/budget_strategy.dart';
import 'strategy/fixed_budget_strategy.dart';
import 'strategy/category_budget_strategy.dart';
import 'strategy/average_based_strategy.dart';
import 'factory/transaction_factory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gestión Finanzas Personales',
      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  const BudgetHomePage({super.key});

  @override
  State<BudgetHomePage> createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  List<Transaction> transactions = [
    Transaction(amount: 500.0, category: 'Salario', date: DateTime(2025, 5, 1), type: TransactionType.income),
    Transaction(amount: 50.0, category: 'Comida', date: DateTime(2025, 5, 3), type: TransactionType.expense),
    Transaction(amount: 100.0, category: 'Transporte', date: DateTime(2025, 5, 5), type: TransactionType.expense),
    Transaction(amount: 200.0, category: 'Comida', date: DateTime(2025, 5, 10), type: TransactionType.expense),
  ];

  double budgetLimit = 700.0;
  String currency = '\€';
  bool notificationsEnabled = true;

  late BudgetStrategy currentStrategy;
  String currentStrategyName = 'Fijo';

  Map<String, double> categoryLimits = {'Comida': 220.0, 'Transporte': 150.0};
  double averageLastMonths = 600.0;

  bool budgetExceeded = false;

  @override
  void initState() {
    super.initState();
    currentStrategy = FixedBudgetStrategy();
    budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
  }

  void changeStrategy(String strategyName) {
    setState(() {
      currentStrategyName = strategyName;
      switch (strategyName) {
        case 'Fijo':
          currentStrategy = FixedBudgetStrategy();
          break;
        case 'Por Categoría':
          currentStrategy = CategoryBudgetStrategy(categoryLimits);
          break;
        case 'Promedio':
          currentStrategy = AverageBasedStrategy(averageLastMonths);
          break;
      }
      budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
    });
  }

  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
    });
  }

  Future<void> showAddTransactionDialog(bool isExpense) async {
    final factory = isExpense ? ExpenseFactory() : IncomeFactory();

    double? amount;
    String? category;
    DateTime selectedDate = DateTime.now();

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isExpense ? 'Añadir Gasto' : 'Añadir Ingreso'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa una cantidad';
                      if (double.tryParse(value) == null) return 'Cantidad no válida';
                      return null;
                    },
                    onSaved: (value) => amount = double.tryParse(value!),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa una categoría';
                      return null;
                    },
                    onSaved: (value) => category = value,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Fecha:'),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.toLocal()}'.split(' ')[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: const Text('Cambiar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final tx = factory.createTransaction(amount!, category!, selectedDate);
                    addTransaction(tx);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> openSettingsDialog() async {
    final budgetController = TextEditingController(text: budgetLimit.toString());
    final currencyController = TextEditingController(text: currency);
    bool notifications = notificationsEnabled;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Presupuesto límite'),
              ),
              TextField(
                controller: currencyController,
                decoration: const InputDecoration(labelText: 'Moneda'),
              ),
              Row(
                children: [
                  const Text('Notificaciones'),
                  Switch(
                    value: notifications,
                    onChanged: (val) => setDialogState(() => notifications = val),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                budgetLimit = double.tryParse(budgetController.text) ?? budgetLimit;
                currency = currencyController.text.isNotEmpty ? currencyController.text : currency;
                notificationsEnabled = notifications;
                budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  String formatAmount(Transaction t) {
    String sign = t.type == TransactionType.expense ? '-' : '+';
    return '$sign$currency${t.amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión Finanzas Personales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: openSettingsDialog,
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Presupuesto límite: $currency${budgetLimit.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: currentStrategyName,
              onChanged: (value) {
                if (value != null) {
                  changeStrategy(value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'Fijo', child: Text('Fijo')),
                DropdownMenuItem(value: 'Por Categoría', child: Text('Por Categoría')),
                DropdownMenuItem(value: 'Promedio', child: Text('Promedio')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              budgetExceeded ? '¡Presupuesto Excedido!' : 'Presupuesto dentro del límite',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: budgetExceeded ? Colors.red : Colors.green,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Transacciones:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return ListTile(
                    title: Text('${t.category}   ${formatAmount(t)}'),
                    subtitle: Text('${t.date.toLocal()}'.split(' ')[0]),
                    leading: Icon(
                      t.type == TransactionType.expense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: t.type == TransactionType.expense ? Colors.red : Colors.green,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          transactions.removeAt(index);
                          budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
                        });
                      },
                      tooltip: 'Eliminar transacción',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        spacing: 12,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btnAddExpense',
            icon: const Icon(Icons.remove_circle_outline),
            label: const Text('Añadir Gasto'),
            onPressed: () => showAddTransactionDialog(true),
            backgroundColor: Colors.red,
          ),
          FloatingActionButton.extended(
            heroTag: 'btnAddIncome',
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Añadir Ingreso'),
            onPressed: () => showAddTransactionDialog(false),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
