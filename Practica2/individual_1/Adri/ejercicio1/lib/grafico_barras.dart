import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class GraficoBarras extends StatelessWidget {
  final List<double> datos;

  const GraficoBarras({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final Map<double, int> frecuencias = {};
    for (var num in datos) {
      frecuencias[num] = (frecuencias[num] ?? 0) + 1;
    }

    final sortedKeys = frecuencias.keys.toList()..sort();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: frecuencias.values.reduce(max).toDouble() + 1,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < sortedKeys.length) {
                  return Text(sortedKeys[index].toStringAsFixed(1),
                      style: TextStyle(fontSize: 10));
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: List.generate(sortedKeys.length, (index) {
          final x = index;
          final y = frecuencias[sortedKeys[index]]!.toDouble();
          return BarChartGroupData(x: x, barRods: [
            BarChartRodData(
              toY: y,
              color: Colors.indigo,
              width: 14,
              borderRadius: BorderRadius.circular(4),
            )
          ]);
        }),
      ),
    );
  }
}
