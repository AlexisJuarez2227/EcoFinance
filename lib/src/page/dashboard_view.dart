import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_arguments.dart';

class DashboardView extends StatelessWidget {
  final DashboardArguments? args;

  const DashboardView({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final userId = args?.userId ?? 0;
    final email = args?.email ?? '';

    void eliminar() async {
      var request = http.Request('DELETE',
          Uri.parse('http://3.225.81.121:3000/cliente/delete/$userId'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pushNamed(
          context,
          '/login',
        );
      } else {
        print(response.reasonPhrase);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Hola'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido $email',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              color: Color(0xFFBEBF8F),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPieChartButton(
                        context, 'Dia', Colors.yellow, '/dayView'),
                    _buildPieChartButton(
                        context, 'Semana', Colors.green, '/weekView'),
                    _buildPieChartButton(
                        context, 'Mes', Colors.red, '/monthView'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Card(
              color: Color(0xFFD9D1B8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildLegend(),
                    SizedBox(height: 16),
                    Center(child: _buildPieChart('Gastos', Colors.green))
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                eliminar();
              },
              child: Text('Eliminar cuenta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color de fondo del botón
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartButton(
      BuildContext context, String label, Color color, String route) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildPieChart(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Dia', Colors.yellow),
        _buildLegendItem('Semana', Colors.green),
        _buildLegendItem('Mes', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
