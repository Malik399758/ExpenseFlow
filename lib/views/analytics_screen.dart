import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ExpenseController>(context);

    final totalIncome = controller.totalIncome;
    final totalExpense = controller.totalExpenses;
    final balance = totalIncome - totalExpense;

    final savingsRate = totalIncome == 0
        ? 0.0
        : ((balance / totalIncome) * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 700),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Header
              const Text(
                "Financial Insights",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Track your financial performance",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              /// KPI Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount:
                MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _statCard(
                    "Income",
                    "\$${totalIncome.toStringAsFixed(2)}",
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                  _statCard(
                    "Expenses",
                    "\$${totalExpense.toStringAsFixed(2)}",
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                  _statCard(
                    "Balance",
                    "\$${balance.toStringAsFixed(2)}",
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                  _statCard(
                    "Savings",
                    "${savingsRate.toStringAsFixed(0)}%",
                    Icons.savings,
                    Colors.amber,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Savings Progress
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Savings Rate",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: SizedBox(
                          height: 220,
                          width: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              /// Background Ring
                              SizedBox(
                                height: 180,
                                width: 180,
                                child: CircularProgressIndicator(
                                  value: 1,
                                  strokeWidth: 14,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.grey.shade200,
                                  ),
                                ),
                              ),

                              /// Progress Ring
                              SizedBox(
                                height: 180,
                                width: 180,
                                child: CircularProgressIndicator(
                                  value: savingsRate / 100,
                                  strokeWidth: 14,
                                  strokeCap: StrokeCap.round,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF14B8A6),
                                  ),
                                ),
                              ),

                              /// Center Content
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${savingsRate.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  const Text(
                                    "Saved",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF14B8A6)
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "\$${balance.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        color: Color(0xFF14B8A6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        savingsRate >= 50
                            ? "Excellent savings performance"
                            : savingsRate >= 25
                            ? "Good progress, keep saving"
                            : "Try reducing expenses",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Pie Chart
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Income vs Expense",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(Icons.pie_chart_outline_rounded),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Chart
                      Center(
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 55,
                              sectionsSpace: 3,
                              startDegreeOffset: -90,
                              sections: [
                                PieChartSectionData(
                                  value: totalIncome <= 0 ? 1 : totalIncome,
                                  color: const Color(0xFF22C55E),
                                  radius: 28,
                                  title: "",
                                ),
                                PieChartSectionData(
                                  value: totalExpense <= 0 ? 1 : totalExpense,
                                  color: const Color(0xFFEF4444),
                                  radius: 28,
                                  title: "",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Balance
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "\$${balance.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Current Balance",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Statistics
                      Row(
                        children: [
                          Expanded(
                            child: _financeInfo(
                              color: const Color(0xFF22C55E),
                              title: "Income",
                              value:
                              "\$${totalIncome.toStringAsFixed(0)}",
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _financeInfo(
                              color: const Color(0xFFEF4444),
                              title: "Expense",
                              value:
                              "\$${totalExpense.toStringAsFixed(0)}",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Bar Chart
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Financial Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 280,
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles:
                                SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles:
                                SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text(
                                            'Income');
                                      case 1:
                                        return const Text(
                                            'Expense');
                                      case 2:
                                        return const Text(
                                            'Balance');
                                      default:
                                        return const SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalIncome,
                                    width: 24,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalExpense,
                                    width: 24,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: balance,
                                    width: 24,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Insights
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Smart Insights",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _insight(
                        Icons.lightbulb_outline,
                        "Savings rate is ${savingsRate.toStringAsFixed(0)}%",
                      ),

                      _insight(
                        Icons.trending_up,
                        balance >= 0
                            ? "Your finances are in positive growth."
                            : "Expenses exceed income.",
                      ),

                      _insight(
                        Icons.account_balance_wallet,
                        "Current balance is \$${balance.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _statCard(
      String title,
      String amount,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: constraints.maxHeight < 90 ? 14 : 18,
                  backgroundColor: color.withOpacity(.15),
                  child: Icon(
                    icon,
                    color: color,
                    size: constraints.maxHeight < 90 ? 14 : 18,
                  ),
                ),

                const SizedBox(height: 4),

                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      amount,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _insight(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  static Widget _financeInfo({
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

