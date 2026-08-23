import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/puntos_servicio/presentation/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: PuntosServicioApp()));
}

class PuntosServicioApp extends StatelessWidget {
  const PuntosServicioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puntos de servicio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
