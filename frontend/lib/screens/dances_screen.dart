import 'package:flutter/material.dart';

class DancesScreen extends StatelessWidget {
  const DancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Todavía no hay bailes cargados en la base de datos.\n\n'
            'Cuando hagas la migración de datos, esta pantalla mostrará el listado de bailes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}