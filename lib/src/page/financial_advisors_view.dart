import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialAdvisorsView extends StatefulWidget {
  const FinancialAdvisorsView({super.key});

  @override
  _FinancialAdvisorsViewState createState() => _FinancialAdvisorsViewState();
}

class _FinancialAdvisorsViewState extends State<FinancialAdvisorsView> {
  late Future<List<Advisor>> _advisorsFuture;

  @override
  void initState() {
    super.initState();
    _advisorsFuture = fetchAdvisors();
  }

  Future<List<Advisor>> fetchAdvisors() async {
    final response = await http.get(Uri.parse('http://3.225.81.121:3000/asesor/getAll'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Advisor.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar los asesores: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBEBF8F),
        title: const Text(
          '¡Te damos la bienvenida!',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar asesor',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: const Color(0xFFD4D4A3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Advisor>>(
                future: _advisorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay asesores disponibles.'));
                  } else {
                    final advisors = snapshot.data!;
                    return ListView.builder(
                      itemCount: advisors.length,
                      itemBuilder: (context, index) {
                        final advisor = advisors[index];
                        return _advisorCard(
                          context,
                          advisor.nombre,
                          'Descripción no disponible', // Puedes ajustar esto según la información real
                          'Experiencia no disponible', // Puedes ajustar esto según la información real
                          'Tarifa no disponible', // Puedes ajustar esto según la información real
                          'lib/src/img/retrato-mujer-joven-sonriente-aislada-sobre-fondo-blanco.png', // Imágenes por defecto, puedes ajustarlas
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _advisorCard(
    BuildContext context,
    String name,
    String description,
    String experience,
    String fee,
    String imageUrl,
  ) {
    return Card(
      color: const Color(0xFFD4D4A3),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(
          'Planificación Financiera\n$name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(description),
            const SizedBox(height: 5),
            Text('Experiencia: $experience'),
            Text('Tarifa: $fee'),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBEBF8F),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Make the button smaller
          ),
          onPressed: () {
            // Handle "Ver más detalles"
          },
          child: const Text('Ver más'),
        ),
      ),
    );
  }
}

class Advisor {
  final int id;
  final String nombre;
  final String password;
  final String email;

  Advisor({
    required this.id,
    required this.nombre,
    required this.password,
    required this.email,
  });

  factory Advisor.fromJson(Map<String, dynamic> json) {
    return Advisor(
      id: json['id'],
      nombre: json['nombre'],
      password: json['password'],
      email: json['email'],
    );
  }
}
