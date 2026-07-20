
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';

class HiveService {
  static const String expenseBoxName = 'expenses';
  static const String categoryBoxName = 'categories';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());

    await Hive.openBox<ExpenseModel>(expenseBoxName);
    await Hive.openBox<CategoryModel>(categoryBoxName);

    // Seed initial categories if empty
    final catBox = Hive.box<CategoryModel>(categoryBoxName);
    if (catBox.isEmpty) {
      await catBox.addAll([
        CategoryModel(name: 'Food', iconCodePoint: 0xe25a),
        CategoryModel(name: 'Salary', iconCodePoint: 0xef63),
        CategoryModel(name: 'Transport', iconCodePoint: 0xe56f),
      ]);
    }
  }
}