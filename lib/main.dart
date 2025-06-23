import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/tarea.dart';
import 'services/tareas_service.dart';
import 'screens/home_screen.dart';
import 'screens/historial_screen.dart';
import 'screens/apodo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TareaAdapter());
  await Hive.openBox<Tarea>('tareasBox');
  await Hive.openBox<Tarea>('historialBox');
  await Hive.openBox<String>('categoriasBox');
  await Hive.openBox<String>('apodoBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => TareasService()..cargarDatos(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bitácora de Ejercicio',
        home: const ApodoScreen(),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/historial': (_) => const HistorialScreen(),
        },
      ),
    ),
  );
}
