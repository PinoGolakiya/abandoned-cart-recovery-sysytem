import 'package:abandoned_cart_recovery_system/core/constants/app_strings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../core/constants/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.analytics,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Revenue card
            _glassCard(
              child: Column(
                children: [
                  const Text(
                    AppStrings.totalRevenue,
                    style: TextStyle(color: AppColors.glass),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹${cart.revenue}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.converted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //Call result pir chart
            _glassCard(
              child: Column(
                children: [
                  const Text(
                    AppStrings.callOutcomes,
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPie(cart),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //Daily trend
            _glassCard(
              child: Column(
                children: [
                  const Text(
                    AppStrings.weeklyCalls,
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [_buildLine(cart)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // High value insight
            _glassCard(
              child: Column(
                children: [
                  const Text(
                    AppStrings.valueInsights,
                    style: TextStyle(color: AppColors.followUp),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "${cart.highValueCount} ${AppStrings.valueCustomer}",
                    style: const TextStyle(color: AppColors.textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Pie data
  List<PieChartSectionData> _buildPie(cart) {
    final stats = cart.callStats;

    return [
      PieChartSectionData(
        value: stats[AppStrings.converted]!.toDouble(),
        color: AppColors.converted,
        title: AppStrings.converted,
        titleStyle: TextStyle(
          fontSize: 11,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: stats[AppStrings.followUp]!.toDouble(),
        color: AppColors.followUp,
        title: AppStrings.follow,
        titleStyle: TextStyle(
          fontSize: 11,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: stats[AppStrings.lost]!.toDouble(),
        color: AppColors.close,
        title: AppStrings.lost,
        titleStyle: TextStyle(
          fontSize: 11,
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  //Line data
  LineChartBarData _buildLine(cart) {
    final values = cart.dailyCalls.values.toList();

    return LineChartBarData(
      isCurved: true,
      spots: List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i].toDouble()),
      ),
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: true),
      color: AppColors.converted,
    );
  }

  // Glass widget
  Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
