import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_arguments.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      var headers = {'Content-Type': 'application/json'};
      var email = _emailController.text;
      var password = _passwordController.text;

      // Intentar iniciar sesión como asesor
      var requestAsesor = http.Request(
        'POST',
        Uri.parse('http://3.225.81.121:3000/asesor/login'),
      );
      requestAsesor.body = json.encode({"email": email, "password": password});
      requestAsesor.headers.addAll(headers);

      http.StreamedResponse responseAsesor = await requestAsesor.send();

      if (responseAsesor.statusCode == 201) {
        final responseBody = await responseAsesor.stream.bytesToString();
        final userData = jsonDecode(responseBody);
        print(userData);

        Navigator.pushNamed(
          context,
          '/homeAsesor',
        );
      } else {
        // Intentar iniciar sesión como cliente si falla como asesor
        var requestCliente = http.Request(
          'POST',
          Uri.parse('http://3.225.81.121:3000/cliente/login'),
        );
        requestCliente.body =
            json.encode({"email": email, "password": password});
        requestCliente.headers.addAll(headers);

        http.StreamedResponse responseCliente = await requestCliente.send();

        if (responseCliente.statusCode == 201) {
          final responseBody = await responseCliente.stream.bytesToString();
          final userData = jsonDecode(responseBody);
          final userId = userData['data']['id'];
          final email = userData['data']['nombre'] as String;

          Navigator.pushNamed(
            context,
            '/dashboard',
            arguments: DashboardArguments(userId: userId, email: email),
          );
        } else {
          print(responseCliente.reasonPhrase);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseCliente.reasonPhrase}')),
          );
        }
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
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homeAsesor');
                },
                child: Text('¿Has olvidado tu contraseña?'),
              ),
              ElevatedButton(
                onPressed: _login,
                child: Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
