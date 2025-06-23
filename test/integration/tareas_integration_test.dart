import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';

import 'package:ejercitapp/services/tareas_service.dart';
import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/screens/home_screen.dart';

void main() {
  group('Test de Integración - Tareas_service + Hive + UI', () {
    setUp(() async {
      await setUpTestHive();
      Hive.registerAdapter(TareaAdapter());
      await Hive.openBox<Tarea>('tareasBox');
      await Hive.openBox<Tarea>('historialBox');
      await Hive.openBox<String>('categoriasBox');
      await Hive.openBox<String>('apodoBox');
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    testWidgets('Agrega una tarea y se muestra en la UI', (WidgetTester tester) async {
      final service = TareasService();
      await service.cargarDatos();

      final tarea = Tarea(
        id: 'int1',
        nombre: 'Test UI',
        categoria: 'Cardio',
        experiencia: 5.0,
        creadaEn: DateTime.now(),
      );

      service.agregarTarea(tarea);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: service,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test UI'), findsOneWidget);
      expect(find.text('Cardio - 5.0% experiencia'), findsOneWidget);
    });

    testWidgets('Eliminar tarea desde el botón y reflejar en pantalla', (WidgetTester tester) async {
      final service = TareasService();
      await service.cargarDatos();

      final tarea = Tarea(
        id: 'int2',
        nombre: 'Eliminar UI',
        categoria: 'Fuerza',
        experiencia: 8.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(tarea);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: service,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Eliminar UI'), findsOneWidget);
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(find.text('Eliminar UI'), findsNothing);
      expect(service.historial.length, 1);
    });

    testWidgets('Completar tarea actualiza la UI (sin imagen)', (WidgetTester tester) async {
      final service = TareasService();
      await service.cargarDatos();

      final tarea = Tarea(
        id: 'int3',
        nombre: 'Completar UI',
        categoria: 'Yoga',
        experiencia: 12.0,
        creadaEn: DateTime.now(),
      );

      service.agregarTarea(tarea);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: service,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final checkButton = find.byIcon(Icons.check).first;
      await tester.tap(checkButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      final tareaCompletada = service.tareas.firstWhere((t) => t.id == 'int3');
      expect(tareaCompletada.completadaEn, isNotNull);
    });
  });
}
