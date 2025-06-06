import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'budget_strategy.dart';
import 'factory/transaction_factory.dart';
import 'services/currency_service.dart';
import 'models/currency_type.dart';
import 'services/transaction_api_controller.dart';
import 'widgets/edit_categories_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gestión Finanzas Personales',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta DEBUG
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


  // List<Transaction> transactions = [
  //   Transaction(id: '1', amount: 500.0, category: 'Salario', date: DateTime(2025, 5, 1), type: TransactionType.income, name: 'Sueldo'),
  //   Transaction(id: '2', amount: 50.0, category: 'Comida', date: DateTime(2025, 5, 3), type: TransactionType.expense, name: 'Pizza'),
  //   Transaction(id: '3', amount: 100.0, category: 'Transporte', date: DateTime(2025, 5, 5), type: TransactionType.expense, name: 'Metro'),
  //   Transaction(id: '4', amount: 200.0, category: 'Comida', date: DateTime(2025, 5, 10), type: TransactionType.expense, name: 'Supermercado'),
  //   Transaction(id: '5', amount: 25.0, category: 'Otro', date: DateTime(2025, 5, 2), type: TransactionType.expense, name: 'Gimnasio'),
  //   Transaction(id: '6', amount: 25.0, category: 'Otro', date: DateTime(2025, 4, 2), type: TransactionType.expense, name: 'Gimnasio'),
  //   Transaction(id: '7', amount: 500.0, category: 'Salario', date: DateTime(2025, 4, 1), type: TransactionType.income, name: 'Sueldo Mayo'),
  //   Transaction(id: '8', amount: 25.0, category: 'Otro', date: DateTime(2025, 3, 2), type: TransactionType.expense, name: 'Gimnasio'),
  //   Transaction(id: '9', amount: 500.0, category: 'Salario', date: DateTime(2025, 3, 1), type: TransactionType.income, name: 'Sueldo Mayo'),  ];

  List<Transaction> transactions = [];

  double budgetLimit = 700.0;
  late CurrencyType currency ;

  late BudgetStrategy currentStrategy;
  String currentStrategyName = 'Fijo';

  Map<String, double> categoryLimits = {'Salario': -500, 'Comida': 220.0, 'Transporte': 150.0, 'Entretenimiento': 100, 'Otros': 50};
  double averageLastMonths = 600.0;

  bool budgetExceeded = false;
  String selectedCategoryFilter = 'Comida';

  final api = TransactionApiController();

  @override
  void initState() {
    super.initState();
    currentStrategy = FixedBudgetStrategy();
    budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
    currency = currencyService.currentCurrencyType;
    api.fetchTransactions().then((_) {
      setState(() {
        transactions = api.transactions;
      });
    });
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
    api.createTransaction(transaction).then((_) {
      setState(() {
        transactions = api.transactions;
      });
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
                    onSaved: (value) {
                      final input = double.tryParse(value!);
                      if (input != null) {
                        amount = currencyService.convertFromTo(
                          input,
                          currencyService.currentCurrencyType,
                          CurrencyType.EUR,
                        );
                      }
                    },                  ),
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
    final budgetController = TextEditingController(
          text: currencyService.convertToCurrent(budgetLimit).toStringAsFixed(2),
    );

    // Al crear los controladores, muestra el valor convertido a la moneda actual
    Map<String, TextEditingController> categoryControllers = {};
    predefinedCategories.forEach((cat) {
      final limiteEnEuros = categoryLimits[cat] ?? 0.0;
      final limiteEnMonedaActual = currencyService.convertToCurrent(limiteEnEuros);
      categoryControllers[cat] = TextEditingController(
        text: limiteEnMonedaActual.toStringAsFixed(2),
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
                value: currency.label,
                onChanged: (value) async{
                  if (value != null) {
                    setState(() {
                      currency = CurrencyTypeExtension.fromInput(value);
                      currencyService.setCurrencyString(value);
                    });
                  }
                  Navigator.pop(context);
                  await openSettingsDialog();
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
              ElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => EditCategoriesDialog(
                      categories: predefinedCategories,
                      onCategoriesChanged: (newCategories)  {
                        setState(() {
                          predefinedCategories
                            ..clear()
                            ..addAll(newCategories);
                          categoryControllers = {
                            for (var cat in predefinedCategories)
                              cat: TextEditingController(
                                text: currencyService.convertToCurrent(categoryLimits[cat] ?? 0.0).toStringAsFixed(2),
                              )
                          };
                        });
                        setState(() async{
                          Navigator.pop(context);
                          await openSettingsDialog();
                        });
                      },
                    ),
                  );
                },
                child: const Text('Editar categorías'),
              ),
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
                budgetLimit = currencyService.convertFromTo(
                  double.tryParse(budgetController.text) ?? budgetLimit,
                  currencyService.currentCurrencyType,
                  CurrencyType.EUR,
                );

                // Guardar límites por categoría
                for (var cat in predefinedCategories) {
                  final val = double.tryParse(categoryControllers[cat]!.text);
                  if (val != null) {
                    // Convierte de la moneda actual a euros antes de guardar
                    final valorEnEuros = currencyService.convertFromTo(
                      val,
                      currencyService.currentCurrencyType,
                      CurrencyType.EUR,
                    );
                    categoryLimits[cat] = valorEnEuros;
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
    bool signed = t.type == TransactionType.expense ;
    return currencyService.formatCurrentCurrency(currencyService.convertToCurrent(t.amount), signed: signed);
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
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
        title: const Text(
          'SpendWise',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.indigo,
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
              'Presupuesto límite: ${currencyService.formatCurrentCurrency(
                  currentStrategyName == 'Por Categoría'
                      ? (categoryLimits[selectedCategoryFilter] ?? 0.0)
                      : currentStrategyName == 'Promedio'
                      ? averageLastMonths
                      : budgetLimit
              )}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: total >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: total >= 0 ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Text(
                'Tienes: ${currencyService.formatCurrentCurrency(currencyService.convertToCurrent(total), signed: total < 0)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: total >= 0 ? Colors.green.shade800 : Colors.red.shade800,
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
            if (currentStrategyName == 'Por Categoría') ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resumen por categorías:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: predefinedCategories.map((category) {
                  final categoryTotal = transactions
                      .where((t) => t.category == category)
                      .fold(0.0, (sum, t) {
                    return t.type == TransactionType.income
                        ? sum + t.amount
                        : sum - t.amount;
                  });

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category),
                      Text(
                        currencyService.formatCurrentCurrency(
                          currencyService.convertToCurrent(categoryTotal),
                          signed: categoryTotal < 0,
                        ),
                        style: TextStyle(
                          color: categoryTotal < 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Transacciones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: sortedMonthKeys.map((monthKey) {
                  final monthTransactions = transactionsByMonth[monthKey]!;
                  monthTransactions.sort((a, b) => b.date.compareTo(a.date));
                  final monthDate = DateTime.parse('$monthKey-01');
                  final monthName = '${_getMonthName(monthDate.month)} ${monthDate.year}';

                  return ExpansionTile(
                    title: Text(
                      monthName,
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
                            final id = t.id;
                            setState(() {
                              transactions.removeWhere((tx) => tx.id == id);
                              budgetExceeded = currentStrategy.isExceeded(budgetLimit, transactions);
                            });
                            api.deleteTransaction(id).catchError((_) {
                              // Si falla, puedes volver a agregar la transacción o mostrar un error
                              // setState(() => transactions.add(t));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al eliminar transacción')),
                              );
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
