import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense_model.dart';
import '../database/hive_service.dart';

class ExpenseController extends ChangeNotifier {
  final Box<ExpenseModel> _box = Hive.box<ExpenseModel>(HiveService.expenseBoxName);

  List<ExpenseModel> get expenses => _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  double get totalIncome => _box.values.where((e) => e.isIncome).fold(0.0, (sum, item) => sum + item.amount);
  double get totalExpenses => _box.values.where((e) => !e.isIncome).fold(0.0, (sum, item) => sum + item.amount);
  double get totalBalance => totalIncome - totalExpenses;

  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}