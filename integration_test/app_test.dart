import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ejercitapp/screens/apodo_screen.dart';
import 'package:ejercitapp/screens/home_screen.dart';
import 'package:ejercitapp/screens/perfil_screen.dart';
import 'package:ejercitapp/screens/historial_screen.dart';
import 'package:ejercitapp/screens/categoria_form_screen.dart';
import 'package:ejercitapp/services/tareas_service.dart';
import 'package:ejercitapp/models/tarea.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TareaAdapter());
    }

    await Hive.openBox<Tarea>('tareasBox');
    await Hive.openBox<Tarea>('historialBox');
    await Hive.openBox<String>('categoriasBox');
    await Hive.openBox<String>('apodoBox');
  });

  tearDownAll(() async {
    await Hive.box<Tarea>('tareasBox').clear();
    await Hive.box<Tarea>('historialBox').clear();
    await Hive.box<String>('categoriasBox').clear();
    await Hive.box<String>('apodoBox').clear();

    await Hive.box<Tarea>('tareasBox').close();
    await Hive.box<Tarea>('historialBox').close();
    await Hive.box<String>('categoriasBox').close();
    await Hive.box<String>('apodoBox').close();
  });

  testWidgets('flujo completo: apodo, categoría, tareas, perfil y eliminación', (WidgetTester tester) async {
    final tareasService = TareasService();

    await tester.pumpWidget(
      ChangeNotifierProvider<TareasService>.value(
        value: tareasService,
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const ApodoScreen(),
            '/home': (context) => const HomeScreen(),
            '/perfil': (context) => const PerfilScreen(),
            '/historial': (context) => const HistorialScreen(),
            '/nueva-categoria': (context) => const CategoriaFormScreen(),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Paso 1: Ingresar apodo
    final apodoInput = find.byKey(const Key('apodo_input'));
    await tester.enterText(apodoInput, 'Tester');

    final guardarBtn = find.text('Guardar y continuar');
    await tester.tap(guardarBtn);
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    // Paso 2: Crear categoría
    Navigator.of(tester.element(find.byType(HomeScreen))).pushNamed('/nueva-categoria');
    await tester.pumpAndSettle();

    final categoriaInput = find.byType(TextFormField);
    await tester.enterText(categoriaInput, 'Yoga');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(tareasService.categorias.contains('Yoga'), isTrue);

    // Paso 3: Crear tarea incompleta
    final tarea1 = Tarea(
      id: 't1',
      nombre: 'Estiramiento',
      categoria: 'Yoga',
      experiencia: 3.0,
      creadaEn: DateTime.now(),
    );
    await tareasService.agregarTarea(tarea1);

    // Paso 4: Crear tarea completada
    final tarea2 = Tarea(
      id: 't2',
      nombre: 'Respiración',
      categoria: 'Yoga',
      experiencia: 7.0,
      creadaEn: DateTime.now().subtract(const Duration(days: 1)),
      completadaEn: DateTime.now().subtract(const Duration(days: 1)),
      clima: 'soleado, 24°C',
    );
    await tareasService.agregarTarea(tarea2);

    // Paso 5: Crear y eliminar una tercera tarea
    final tarea3 = Tarea(
      id: 't3',
      nombre: 'Tarea temporal',
      categoria: 'Yoga',
      experiencia: 5.0,
      creadaEn: DateTime.now(),
    );
    await tareasService.agregarTarea(tarea3);

    // Confirmamos que fue agregada
    expect(tareasService.tareas.any((t) => t.id == 't3'), isTrue);

    // Eliminar la tarea
    tareasService.eliminarTarea(tarea3.id);
    await tester.pumpAndSettle();
    expect(tareasService.historial.any((t) => t.id == 't3'), isTrue);
    expect(tareasService.tareas.any((t) => t.id == 't3'), isFalse);

    // Paso 6: Ir a pantalla de perfil
    Navigator.of(tester.element(find.byType(HomeScreen))).pushNamed('/perfil');
    await tester.pumpAndSettle();

    expect(find.byType(PerfilScreen), findsOneWidget);
    expect(find.textContaining('Perfil de Tester'), findsOneWidget);

    expect(find.text('Tareas completadas vs inconclusas:'), findsOneWidget);
    expect(find.text('Experiencia acumulada por día:'), findsOneWidget);
    expect(find.text('Temperatura por día (°C):'), findsOneWidget);
    expect(find.text('Clima por día:'), findsOneWidget);

    // Paso 7: Ir a pantalla de historial
    Navigator.of(tester.element(find.byType(PerfilScreen))).pushNamed('/historial');
    await tester.pumpAndSettle();

    expect(find.byType(HistorialScreen), findsOneWidget);
    expect(find.text('Tarea temporal'), findsOneWidget);
    expect(find.textContaining('Eliminada: Yoga'), findsOneWidget);
  });
}
