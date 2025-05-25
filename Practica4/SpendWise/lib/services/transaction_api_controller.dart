import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionApiController {
  // En WSl comprobar al iniciar que la IP es correcta con "hostname -I"
  // Lanzar el servidor RoR con "rails s -b 0.0.0.0"
  final String baseUrl = 'http://172.28.16.241:3000/transactions';

  // Lista local usada por la UI
  List<Transaction> transactions = [];

  // Cargar todas las transacciones al inicio
  Future<void> fetchTransactions() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      transactions = data.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar transacciones');
    }
  }

  // Crear una nueva transacción
  Future<String> createTransaction(Transaction tx) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'transaction': tx.toJson()}),
    );
    if (response.statusCode == 201) {
      final newTx = Transaction.fromJson(json.decode(response.body));
      transactions.add(newTx);
      return newTx.id; // Devuelve el id nuevo
    } else {
      throw Exception('Error al crear transacción');
    }
  }

  // Actualizar una transacción existente
  Future<void> updateTransaction(String id, Transaction tx) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'transaction': tx.toJson()}),
    );
    if (response.statusCode == 200) {
      final index = transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        transactions[index] = Transaction.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Error al actualizar transacción');
    }
  }

  // Eliminar una transacción
  Future<void> deleteTransaction(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200 || response.statusCode == 204) {
      transactions.removeWhere((t) => t.id == id);
    } else {
      throw Exception('Error al eliminar transacción');
    }
  }
}
