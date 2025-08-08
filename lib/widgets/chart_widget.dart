import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 1000,
            minY: 0,
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 200,
                  reservedSize: 40,  // space allocated for the Y-axis labels
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8), // padding right so labels don't collide with bars
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                    if (value.toInt() < 0 || value.toInt() >= months.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      months[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),

            barGroups: _buildBarGroups(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final values = [500, 700, 300, 900, 400, 600, 800];

    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index].toDouble(),
            color:const Color(0xffFF1901) ,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }
}
