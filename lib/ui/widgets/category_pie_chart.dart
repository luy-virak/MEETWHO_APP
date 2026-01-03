import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meetwho/data/enums/category.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<Category, int> categoryCounts;

  const CategoryPieChart({super.key, required this.categoryCounts});

  @override
  Widget build(BuildContext context) {
    final int total = categoryCounts.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return const Center(
        child: Text("No data", style: TextStyle(color: Colors.white)),
      );
    }

    return Row(
      children: [
        /// PIE CHART
        SizedBox(
          width: 180,
          height: 180,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              sections: categoryCounts.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  color: _categoryColor(entry.key),
                  title: "${((entry.value / total) * 100).toStringAsFixed(0)}%",
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(width: 20),

        /// LEGEND
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryCounts.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _categoryColor(entry.key),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _label(entry.key),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "(${entry.value})",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _categoryColor(Category category) {
    switch (category) {
      case Category.work:
        return Colors.red;
      case Category.project:
        return Colors.blue;
      case Category.personal:
        return Colors.green;
      case Category.team:
        return Colors.yellow;
      case Category.school:
        return Colors.pink;
      case Category.other:
        return Colors.grey;
    }
  }

  String _label(Category category) {
    switch (category) {
      case Category.work:
        return "Work";
      case Category.project:
        return "Project";
      case Category.personal:
        return "Personal";
      case Category.team:
        return "Team";
      case Category.school:
        return "School";
      case Category.other:
        return "Other";
    }
  }
}
