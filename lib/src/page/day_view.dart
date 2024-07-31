import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DayView extends StatelessWidget {
  const DayView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimePeriodButton(context, 'Semana', '/weekView'),
                _buildTimePeriodButton(context, 'Dia', null, selected: true),
                _buildTimePeriodButton(context, 'Mes', '/monthView'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: const [
                  Text(
                    'Dia 6',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Junio 11 - Junio 15',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                height: 240,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xFFBEBF8F)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 450),
                          FlSpot(2, 350),
                          FlSpot(3, 400),
                          FlSpot(4, 300),
                          FlSpot(5, 459.23),
                        ],
                        isCurved: true,
                        colors: [const Color(0xFFFFE180)],
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData:  FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBEBF8F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '\$459.23',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total gastado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/financialAdvisors');
                    },
                    child: const Text(
                      'Consultar con un asesor?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodButton(BuildContext context, String label, String? route, {bool selected = false}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selected ? const Color(0xFFBEBF8F) : Colors.transparent,
        foregroundColor: Colors.black,
      ),
      onPressed: route != null
          ? () {
              Navigator.pushNamed(context, route);
            }
          : null,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}