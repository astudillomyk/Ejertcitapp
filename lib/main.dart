import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- ✅ NUEVO

import 'models/tarea.dart';
import 'services/tareas_service.dart';

import 'screens/home_screen.dart';
import 'screens/historial_screen.dart';
import 'screens/apodo_screen.dart';
import 'screens/perfil_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // <-- ✅ Carga de .env

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const ApodoScreen(),
          '/home': (_) => const HomeScreen(),
          '/historial': (_) => const HistorialScreen(),
          '/perfil': (_) => const PerfilScreen(),
        },
      ),
    ),
  );
}
