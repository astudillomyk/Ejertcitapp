import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/tareas_service.dart';
import 'screens/home_screen.dart';
import 'screens/historial_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TareasService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bitácora de Ejercicio',
        home: const HomeScreen(),
        routes: {
          '/historial': (_) => const HistorialScreen(),
        },
      ),
    ),
  );
}
