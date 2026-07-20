import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/expense_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/responsive_builder.dart';
import '../widgets/stat_card.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseController = Provider.of<ExpenseController>(context);
    final themeController = Provider.of<ThemeController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen())),
          ),
          IconButton(
            icon: Icon(themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeController.toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_expense_hero',
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        label: const Text('Add Record'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
      body: ResponsiveBuilder(
        mobileView: _buildDashboardContent(context, expenseController, crossAxisCount: 2),
        tabletView: _buildDashboardContent(context, expenseController, crossAxisCount: 4),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, ExpenseController controller, {required int crossAxisCount}) {
    // 1. Fetch live responsive dimension variables
    final Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    // 2. Compute dynamic grid card aspect ratios dynamically based on form footprint scale rules
    double computedAspectRatio = 2.2;
    if (screenSize.width > 600) {
      // Tablet layout grids
      computedAspectRatio = orientation == Orientation.landscape ? 3.0 : 2.5;
    } else {
      // Compact phone target allocations
      if (screenSize.width < 360) {
        computedAspectRatio = 1.6; // Ultra tight phone screens
      } else if (orientation == Orientation.landscape) {
        computedAspectRatio = 3.2; // Phone side rotations
      }
    }

    // 3. Keep layout clean by scaling vertical margins based on display height
    final double paddingHorizontal = screenSize.width > 600 ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back,", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const Text("Yaseen Malik", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.4,
            ),
            delegate: SliverChildListDelegate([
              StatCard(
                title: "Balance",
                amount: "\$${controller.totalBalance.toStringAsFixed(0)}",
                icon: Icons.account_balance_wallet_rounded,
                iconBgColor: const Color(0xFF1E3A8A),
              ),

              StatCard(
                title: "Income",
                amount: "\$${controller.totalIncome.toStringAsFixed(0)}",
                icon: Icons.trending_up_rounded,
                iconBgColor: const Color(0xFF22C55E),
              ),

              StatCard(
                title: "Expenses",
                amount: "\$${controller.totalExpenses.toStringAsFixed(0)}",
                icon: Icons.trending_down_rounded,
                iconBgColor: const Color(0xFFEF4444),
              ),

              StatCard(
                title: "Savings",
                amount:
                "\$${(controller.totalIncome - controller.totalExpenses).toStringAsFixed(0)}",
                icon: Icons.savings_rounded,
                iconBgColor: const Color(0xFFF59E0B),
              ),
            ]),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          controller.expenses.isEmpty
              ? const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("No transactions recorded yet."))
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = controller.expenses[index];
                return ExpenseCard(
                  expense: item,
                  onDelete: () => controller.deleteExpense(item.id),
                );
              },
              childCount: controller.expenses.length,
            ),
          ),
        ],
      ),
    );
  }
}