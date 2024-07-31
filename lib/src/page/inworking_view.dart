import 'package:flutter/material.dart';

class UnderConstructionView extends StatelessWidget {
  const UnderConstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('En Construcción'),
      ),
      body: Center(
        child: Text(
          'Esta página está en construcción',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
