import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconBgColor;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
            BorderRadius.circular(AppConstants.borderRadiusLarge),
            boxShadow: isDark
                ? null
                : [
              const BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: cardHeight < 80 ? 16 : 20,
                backgroundColor: iconBgColor.withOpacity(0.15),
                child: Icon(
                  icon,
                  color: iconBgColor,
                  size: cardHeight < 80 ? 16 : 20,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: cardHeight < 80 ? 10 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          amount,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: cardHeight < 80 ? 13 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}