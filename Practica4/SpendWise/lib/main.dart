import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'budget_strategy.dart';
import 'factory/transaction_factory.dart';
import 'services/currency_service.dart';
import 'services/notification_service.dart';
import 'models/currency_type.dart';

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
  final List<String> predefinedCategories = ['Comida', 'Transporte', 'Salario', 'Entretenimiento', 'Otros'];
  final CurrencyService currencyService = CurrencyService();
  final NotificationService notificationService = NotificationService();


  List<Transaction> transactions = [
    Transaction(amount: 500.0, category: 'Salario', date: DateTime(2025, 5, 1), type: TransactionType.income, name: 'Sueldo'),
    Transaction(amount: 50.0, category: 'Comida', date: DateTime(2025, 5, 3), type: TransactionType.expense, name: 'Pizza'),
    Transaction(amount: 100.0, category: 'Transporte', date: DateTime(2025, 5, 5), type: TransactionType.expense, name: 'Metro'),
    Transaction(amount: 200.0, category: 'Comida', date: DateTime(2025, 5, 10), type: TransactionType.expense, name: 'Supermercado'),
    Transaction(amount: 25.0, category: 'Otro', date: DateTime(2025, 5, 2), type: TransactionType.expense, name: 'Gimnasio'),
    Transaction(amount: 25.0, category: 'Otro', date: DateTime(2025, 4, 2), type: TransactionType.expense, name: 'Gimnasio'),
    Transaction(amount: 500.0, category: 'Salario', date: DateTime(2025, 4, 1), type: TransactionType.income, name: 'Sueldo Mayo'),
    Transaction(amount: 25.0, category: 'Otro', date: DateTime(2025, 3, 2), type: TransactionType.expense, name: 'Gimnasio'),
    Transaction(amount: 500.0, category: 'Salario', date: DateTime(2025, 3, 1), type: TransactionType.income, name: 'Sueldo Mayo'),
  ];

  double budgetLimit = 700.0;
  //String currency = '\€'; // Eliminar

  late BudgetStrategy currentStrategy;
  String currentStrategyName = 'Fijo';

  Map<String, double> categoryLimits = {'Salario': -500, 'Comida': 220.0, 'Transporte': 150.0, 'Entretenimiento': 100, 'Otros': 50};
  double averageLastMonths = 600.0;

  bool budgetExceeded = false;
  String selectedCategoryFilter = 'Comida';

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
    // Primero actualizamos la lista
    setState(() {
      transactions.add(transaction);
    });

    // Recalculamos el presupuesto EXTERNO a setState
    final exceeded = currentStrategy.isExceeded(budgetLimit, transactions);

    setState(() {
      budgetExceeded = exceeded;
    });

    // Mostrar pop-up si se excede
    if (exceeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Presupuesto excedido!'),
            content: Text(
              currentStrategyName == 'Por Categoría'
                  ? 'Has superado el límite de la categoría "${transaction.category}".'
                  : 'Has superado el límite de tu presupuesto.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      });
    }
  }



  Future<void> showAddTransactionDialog(bool isExpense) async {
    final factory = isExpense ? ExpenseFactory() : IncomeFactory();

    double? amount;
    String? category = predefinedCategories.first;
    String? name;
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
                      if (double.tryParse(value) !<= 0) return 'Cantidad no válida';
                      return null;
                    },
                    onSaved: (value) => amount = double.tryParse(value!),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    value: category,
                    items: predefinedCategories
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                    onSaved: (value) {
                      category = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre o descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa un nombre';
                      return null;
                    },
                    onSaved: (value) => name = value,
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
                    final tx = factory.createTransaction(amount!, category ?? 'Sin categoría', selectedDate, name!);
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
    // final currencyController = TextEditingController(text: currency); // eliminar

    Map<String, TextEditingController> categoryControllers = {};
    predefinedCategories.forEach((cat) {
      categoryControllers[cat] = TextEditingController(
        text: categoryLimits[cat]?.toString() ?? '',
      );
    });

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: currencyService.currentCurrencyType.label,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      currencyService.setCurrencyString(value);
                    });
                  }
                },
                items: currencyService.getAllCurrencyLabels()
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
              ),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Presupuesto límite general'),
              ),
              // TextField(
              //   controller: currencyController,
              //   decoration: const InputDecoration(labelText: 'Moneda'),
              // ),
              const SizedBox(height: 16),
              const Text('Límites por categoría:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...predefinedCategories.map((cat) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: categoryControllers[cat],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Límite para $cat'),
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                budgetLimit = double.tryParse(budgetController.text) ?? budgetLimit;
                //currency = currencyController.text.isNotEmpty ? currencyController.text : currency; // eliminar

                // Guardar límites por categoría
                for (var cat in predefinedCategories) {
                  final val = double.tryParse(categoryControllers[cat]!.text);
                  if (val != null) {
                    categoryLimits[cat] = val;
                  }
                }

                // Recalcular estrategia si es por categoría
                if (currentStrategyName == 'Por Categoría') {
                  currentStrategy = CategoryBudgetStrategy(categoryLimits);
                }

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
    //String sign = t.type == TransactionType.expense ? '-' : '+'; // eliminar
    //return '$sign$currency${t.amount.toStringAsFixed(2)}';
    bool signed = t.type == TransactionType.expense ;
    return currencyService.convertToCurrent(t.amount, signed: signed);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = currentStrategyName == 'Por Categoría'
        ? transactions.where((tx) => tx.category == selectedCategoryFilter).toList()
        : transactions;

    final total = filteredTransactions.fold(0.0, (sum, tx) {
      return tx.type == TransactionType.income ? sum + tx.amount : sum - tx.amount;
    });

    final transactionsByMonth = <String, List<Transaction>>{};
    for (final tx in filteredTransactions) {
      final monthKey = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
      transactionsByMonth.putIfAbsent(monthKey, () => []).add(tx);
    }

    final sortedMonthKeys = transactionsByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // más recientes primero

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
            Text(
              'Presupuesto límite: ${currencyService.convertToCurrent(
                  currentStrategyName == 'Por Categoría'
                      ? (categoryLimits[selectedCategoryFilter] ?? 0.0)
                      : currentStrategyName == 'Promedio'
                      ? averageLastMonths
                      : budgetLimit
              )}',
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: total >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: total >= 0 ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Text(
                'Tienes: ${currencyService.convertToCurrent(total, signed: total < 0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: total >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ),
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
            if (currentStrategyName == 'Por Categoría') ...[
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedCategoryFilter,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategoryFilter = value;
                    });
                  }
                },
                items: predefinedCategories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Transacciones:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: sortedMonthKeys.map((monthKey) {
                  final monthTransactions = transactionsByMonth[monthKey]!;
                  monthTransactions.sort((a, b) => b.date.compareTo(a.date));
                  final monthName = '${DateTime.parse('$monthKey-01').month.toString().padLeft(2, '0')}/${DateTime.parse('$monthKey-01').year}';
                  return ExpansionTile(
                    title: Text(
                      'Mes: $monthName',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: monthTransactions.map((t) {
                      final formattedDate = '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}';
                      return ListTile(
                        title: Text('${t.name} | ${formatAmount(t)}'),
                        subtitle: Text('${t.category} | $formattedDate'),
                        leading: Icon(
                          t.type == TransactionType.expense ? Icons.arrow_downward : Icons.arrow_upward,
                          color: t.type == TransactionType.expense ? Colors.red : Colors.green,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              transactions.remove(t);
                              budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
                            });
                          },
                          tooltip: 'Eliminar transacción',
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
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
