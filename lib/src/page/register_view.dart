import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_arguments.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool? _isAdvisor;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce tu nombre';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce tu email';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Introduce un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      var headers = {'Content-Type': 'application/json'};
      var url = _isAdvisor == true
          ? 'http://3.225.81.121:3000/asesor/crear'
          : 'http://3.225.81.121:3000/cliente/crear';
      var request = http.Request(
        'POST',
        Uri.parse(url),
      );
      request.body = json.encode({
        "nombre": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "isAdvisor": _isAdvisor
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final userData = jsonDecode(responseBody);
        final userId = userData['data']['id']; // Suponiendo que ID viene en la respuesta
        final email = userData['data']['nombre'];

        if (_isAdvisor == true) {
          Navigator.pushNamed(
            context,
            '/homeAsesor',
            arguments: DashboardArguments(userId: userId, email: email),
          );
        } else {
          Navigator.pushNamed(
            context,
            '/dashboard',
            arguments: DashboardArguments(userId: userId, email: email),
          );
        }
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    }
  }

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
        title: Text('EcoFinance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: _validateName,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              Row(
                children: <Widget>[
                  Text('¿Eres un asesor?'),
                  Spacer(),
                  Radio<bool>(
                    value: true,
                    groupValue: _isAdvisor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAdvisor = value;
                      });
                    },
                  ),
                  Text('Sí'),
                  Radio<bool>(
                    value: false,
                    groupValue: _isAdvisor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAdvisor = value;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
