import 'dart:convert'; // Para usar jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardAsesorView extends StatefulWidget {
  const DashboardAsesorView({super.key});

  @override
  _DashboardAsesorViewState createState() => _DashboardAsesorViewState();
}

class _DashboardAsesorViewState extends State<DashboardAsesorView> {
  List<dynamic> _asesorados = [];

  @override
  void initState() {
    super.initState();
    _fetchAsesorados();
  }

  Future<void> _fetchAsesorados() async {
    final response = await http.get(Uri.parse('http://3.225.81.121:3000/cliente/getAll'));

    if (response.statusCode == 200) {
      setState(() {
        _asesorados = jsonDecode(response.body);
      });
    } else {
      // Manejo de errores
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Acción para regresar
            },
          ),
          title: Text('Asesorados'),
        ),
        body: ListView.builder(
          itemCount: _asesorados.length,
          itemBuilder: (context, index) {
            final asesorado = _asesorados[index];
            return asesoradoCard(asesorado['nombre'], 'lib/src/img/Image.png');
          },
        ),
      ),
    );
  }

  Widget asesoradoCard(String name, String imagePath) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.green[200],
      child: ListTile(
        leading: Image.asset(imagePath),
        title: Text(name),
        trailing: ElevatedButton(
          onPressed: () {
            // Acción para ver más detalles
          },
          child: Text('Ver más detalle'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Color de fondo
            foregroundColor: Colors.white, // Color de texto
          ),
        ),
      ),
    );
  }
}
