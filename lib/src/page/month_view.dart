import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthView extends StatelessWidget {
  const MonthView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(''),
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
                _buildTimePeriodButton(context, 'Mes', null, selected: true),
                _buildTimePeriodButton(context, 'Dia', '/dayView'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    'Mes 1',
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
            SizedBox(height: 40),
            Center(
              child: Container(
                height: 240,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Color(0xFFBEBF8F)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(1, 450),
                          FlSpot(2, 350),
                          FlSpot(3, 400),
                          FlSpot(4, 300),
                          FlSpot(5, 459.23),
                        ],
                        isCurved: true,
                        colors: [Color(0xFFFF6565)],
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFBEBF8F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
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
                  SizedBox(height: 16),
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
        backgroundColor: selected ? Color(0xFFBEBF8F) : Colors.transparent,
        foregroundColor: Colors.black,
      ),
      onPressed: route != null
          ? () {
              Navigator.pushNamed(context, route);
            }
          : null,
      child: Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}