import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';

import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/services/tareas_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Carga y Estrés (Simplificadas)', () {
    late TareasService service;

    setUpAll(() async {
      await setUpTestHive();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TareaAdapter());
      }
      await Hive.openBox<Tarea>('tareasBox');
      await Hive.openBox<Tarea>('historialBox');
      await Hive.openBox<String>('categoriasBox');
      await Hive.openBox<String>('apodoBox');
    });

    setUp(() async {
      service = TareasService();
      await service.cargarDatos();
    });

    tearDownAll(() async {
      await Hive.box<Tarea>('tareasBox').close();
      await Hive.box<Tarea>('historialBox').close();
      await Hive.box<String>('categoriasBox').close();
      await Hive.box<String>('apodoBox').close();
      await tearDownTestHive();
    });

    test('TC-01: Carga de 100 tareas sin errores', () async {
      for (int i = 0; i < 100; i++) {
        await service.agregarTarea(
          Tarea(
            id: 'id_$i',
            nombre: 'Tarea $i',
            categoria: 'Prueba',
            experiencia: (i % 100).toDouble(),
            creadaEn: DateTime.now(),
          ),
        );
      }
      expect(service.tareas.length, 100);
    });

    test('TC-02: Completar 50 tareas con imágenes simuladas', () async {
      if (service.tareas.length < 50) {
        for (int i = service.tareas.length; i < 50; i++) {
          await service.agregarTarea(
            Tarea(
              id: 'img_id_$i',
              nombre: 'Con Imagen $i',
              categoria: 'Imagen',
              experiencia: 10,
              creadaEn: DateTime.now(),
            ),
          );
        }
      }

      for (var tarea in service.tareas.take(50)) {
        service.completarTarea(tarea.id, '/fake/imagen_pesada_$tarea.jpg');
      }

      final completadas = service.tareas.where((t) => t.completadaEn != null).length;
      expect(completadas, greaterThanOrEqualTo(50));
    });

    test('TC-03: Navegar (simulado) entre 50 tareas', () async {
      final lista = service.tareas.take(50).toList();
      final stopwatch = Stopwatch()..start();

      for (final tarea in lista) {
        tarea.nombre; // Simula render o acceso
      }

      stopwatch.stop();
      print('Navegar entre 50 tareas tomó: ${stopwatch.elapsedMilliseconds} ms');
      expect(stopwatch.elapsedMilliseconds < 200, true); // fluido <200ms
    });

    test('TC-04: Crear y alternar entre 30 categorías', () async {
      for (int i = 0; i < 30; i++) {
        service.agregarCategoria('Cat_$i');
      }

      expect(service.categorias.length >= 30, true);
      expect(service.categorias.contains('Cat_0'), true);
    });

    test('TC-05: Alternar entre vistas (historial y tareas)', () async {
      for (int i = 0; i < 10; i++) {
        service.agregarTarea(
          Tarea(
            id: 'v_id_$i',
            nombre: 'Vista $i',
            categoria: 'Test',
            experiencia: 0,
            creadaEn: DateTime.now(),
          ),
        );
      }

      for (int i = 0; i < 5; i++) {
        final tarea = service.tareas[i];
        service.eliminarTarea(tarea.id);
      }

      final total = service.tareas.length + service.historial.length;
      expect(total >= 10, true);
    });
  });
}
